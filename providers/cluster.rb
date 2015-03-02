#
# Cookbook Name:: rabbitmq
# Provider:: cluster
#
# Author: Sunggun Yu <sunggun.dev@gmail.com>
# Copyright (C) 2015 Sunggun Yu
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include Chef::Mixin::ShellOut

use_inline_resources

# Get ShellOut
def get_shellout(cmd)
  sh_cmd = Mixlib::ShellOut.new(cmd)
  sh_cmd.environment['HOME'] = ENV.fetch('HOME', '/root')
  return sh_cmd
end

# Execute rabbitmqctl command with args
def run_rabbitmqctl(*args)
  cmd = "rabbitmqctl #{args.join(' ')}"
  Chef::Log.debug("[rabbitmq_cluster] Executing #{cmd}")
  cmd = get_shellout(cmd)
  cmd.run_command
  begin
    cmd.error!
    Chef::Log.debug("[rabbitmq_cluster] #{cmd.stdout}")
  rescue
    Chef::Application.fatal!("[rabbitmq_cluster] #{cmd.stderr}")
  end
end

# Get cluster status result
def cluster_status
  # execute > rabbitmqctl cluster_status | sed "1d" | tr "\n" " " | tr -d " "
  # rabbitmqctl cluster_status returns "Cluster status of node rabbit@rabbit1 ..." at the first line.
  # To parse the result string, it is removed by sed "1d"
  cmd = 'rabbitmqctl cluster_status | sed "1d" | tr "\n" " " | tr -d " "'
  Chef::Log.debug("[rabbitmq_cluster] Executing #{cmd}")
  cmd = get_shellout(cmd)
  cmd.run_command
  cmd.error!
  result = cmd.stdout.chomp
  Chef::Log.debug("[rabbitmq_cluster] rabbitmqctl cluster_status : #{result}")
  return result
end

# Match regex pattern from result of rabbitmqctl cluster_status
def match_pattern_cluster_status(cluster_status, pattern)
  if cluster_status.nil? || cluster_status.to_s.empty?
    Chef::Application.fatal!('[rabbitmq_cluster] cluster_status should not be empty')
  end
  match = cluster_status.match(pattern)
  return match[2]
end

# Get currently joined cluster name from result string of "rabbitmqctl cluster_status"
def current_cluster_name(cluster_status)
  pattern = '({cluster_name,<<")(.*?)(">>})'
  result = match_pattern_cluster_status(cluster_status, pattern)
  Chef::Log.debug("[rabbitmq_cluster] current_cluster_name : #{result}")
  return result
end

# Get running nodes
def running_nodes(cluster_status)
  pattern = '({running_nodes,\[)(.*?)(\]})'
  result = match_pattern_cluster_status(cluster_status, pattern)
  Chef::Log.debug("[rabbitmq_cluster] running_nodes : #{result}")
  return result.split(',')
end

# Get disc nodes
def disc_nodes(cluster_status)
  pattern = '({disc,\[)(.*?)(\]})'
  result = match_pattern_cluster_status(cluster_status, pattern)
  Chef::Log.debug("[rabbitmq_cluster] disc_nodes : #{result}")
  return result.split(',')
end

# Get ram nodes
def ram_nodes(cluster_status)
  pattern = '({ram,\[)(.*?)(\]})'
  result = match_pattern_cluster_status(cluster_status, pattern)
  Chef::Log.debug("[rabbitmq_cluster] ram_nodes : #{result}")
  return result.split(',')
end

# Get node name
def node_name
  # execute > rabbitmqctl eval 'node().'
  cmd = 'rabbitmqctl eval "node()."'
  Chef::Log.debug("[rabbitmq_cluster] Executing #{cmd}")
  cmd = get_shellout(cmd)
  cmd.run_command
  cmd.error!
  result = cmd.stdout.chomp
  Chef::Log.debug("[rabbitmq_cluster] node name : #{result}")
  return result
end

# Get cluster_node_type of current node
def current_cluster_node_type(node_name, cluster_status)
  if disc_nodes(cluster_status).include?(node_name)
    return 'disc'
  end
  if ram_nodes(cluster_status).include?(node_name)
    return 'ram'
  end
  ''
end

# Parse hash string of cluster_nodes to JSON object
def parse_cluster_nodes_string(cluster_nodes)
  JSON.parse(cluster_nodes.gsub('=>', ':'))
end

# Checking node is joined in cluster
def joined_cluster?(node_name, cluster_status)
  running_nodes(cluster_status).include?(node_name)
end

# Join cluster.
def join_cluster(cluster_name)
  cmd = "rabbitmqctl join_cluster --ram #{cluster_name}"
  Chef::Log.debug("[rabbitmq_cluster] Executing #{cmd}")
  cmd = get_shellout(cmd)
  cmd.run_command
  begin
    cmd.error!
    Chef::Log.info("[rabbitmq_cluster] #{cmd.stdout}")
  rescue
    err = cmd.stderr
    Chef::Log.warn("[rabbitmq_cluster] #{err}")
    if err.include?('{ok,already_member}')
      Chef::Log.info('[rabbitmq_cluster] Node is already member of cluster, error will be ignored.')
    elsif err.include?('cannot_cluster_node_with_itself')
      Chef::Log.info('[rabbitmq_cluster] Cannot cluster node itself, error will be ignored.')
    else
      Chef::Application.fatal!("[rabbitmq_cluster] #{err}")
    end
  end
end

# Change cluster node type
def change_cluster_node_type(cluster_node_type)
  cmd = "rabbitmqctl change_cluster_node_type #{cluster_node_type}"
  Chef::Log.debug("[rabbitmq_cluster] Executing #{cmd}")
  cmd = get_shellout(cmd)
  cmd.run_command
  begin
    cmd.error!
    Chef::Log.debug("[rabbitmq_cluster] #{cmd.stdout}")
  rescue
    err = cmd.stderr
    Chef::Log.warn("[rabbitmq_cluster] #{err}")
    if err.include?('{not_clustered,"Non-clustered nodes can only be disc nodes."}')
      Chef::Log.info('[rabbitmq_cluster] Node is not clustered yet, error will be ignored.')
    else
      Chef::Application.fatal!("[rabbitmq_cluster] #{err}")
    end
  end
end

########################################################################################################################
# Actions
#  :join
#  :change_cluster_node_type
########################################################################################################################

# Action for joining cluster
action :join do
  Chef::Log.info('[rabbitmq_cluster] Action join ... ')

  Chef::Application.fatal!('rabbitmq_cluster with action :join requires a non-nil/empty cluster_nodes.') if new_resource.cluster_nodes.nil? || new_resource.cluster_nodes.empty?

  _cluster_status = cluster_status
  _node_name = node_name
  _node_name_to_join = parse_cluster_nodes_string(new_resource.cluster_nodes).first['name']
  _cluster_name =  new_resource.cluster_name.nil? || new_resource.cluster_name.empty? ? _node_name_to_join : new_resource.cluster_name

  if _node_name == _node_name_to_join
    Chef::Log.warn('[rabbitmq_cluster] Trying to join cluster node itself. Joining cluster will be skipped.')
  elsif current_cluster_name(_cluster_status) == _cluster_name && joined_cluster?(_node_name_to_join, _cluster_status)
    Chef::Log.warn("[rabbitmq_cluster] Node is already member of #{_cluster_name} and joined in #{_node_name_to_join}. Joining cluster will be skipped.")
  else
    run_rabbitmqctl('stop_app')
    join_cluster(_node_name_to_join)
    run_rabbitmqctl('start_app')
    Chef::Log.info("[rabbitmq_cluster] Node #{_node_name} joined in #{_node_name_to_join}")
    Chef::Log.info("#{cluster_status}")
  end
end

# Action for set cluster name
action :set_cluster_name do
  Chef::Application.fatal!('rabbitmq_cluster with action :join requires a non-nil/empty cluster_nodes.') if new_resource.cluster_nodes.nil? || new_resource.cluster_nodes.empty?
  _cluster_status = cluster_status
  _cluster_name = new_resource.cluster_name
  unless current_cluster_name(_cluster_status) == _cluster_name
    unless _cluster_name.empty?
      run_rabbitmqctl("set_cluster_name #{_cluster_name}")
      Chef::Log.info("[rabbitmq_cluster] Cluster name has been set : #{current_cluster_name(cluster_status)}")
    end
  end
end

# Action for changing cluster node type
action :change_cluster_node_type do
  Chef::Log.info('[rabbitmq_cluster] Action change_cluster_node_type ... ')

  Chef::Application.fatal!('rabbitmq_cluster with action :join requires a non-nil/empty cluster_nodes.') if new_resource.cluster_nodes.nil? || new_resource.cluster_nodes.empty?

  _cluster_status = cluster_status
  _node_name = node_name
  _current_cluster_node_type = current_cluster_node_type(_node_name, _cluster_status)
  _cluster_node_type = parse_cluster_nodes_string(new_resource.cluster_nodes).select { |node| node['name'] == _node_name }.first['type']

  if _current_cluster_node_type == _cluster_node_type
    Chef::Log.warn('[rabbitmq_cluster] Skip changing cluster node type : trying to change to same cluster node type')
    node_type_changeable = false
  else
    if _cluster_node_type == 'ram'
      if _current_cluster_node_type == 'disc' && disc_nodes(_cluster_status).length < 2
        Chef::Log.warn('[rabbitmq_cluster] At least one disc node is required for rabbitmq cluster. Changing cluster node type will be ignored.')
        node_type_changeable = false
      else
        node_type_changeable = true
      end
    elsif _cluster_node_type == 'disc'
      node_type_changeable = true
    else
      Chef::Log.warn("[rabbitmq_cluster] Unexpected cluster_note_type #{_cluster_node_type}. Changing cluster node type will be ignored.")
      node_type_changeable = false
    end
  end

  # Change cluster node type
  if node_type_changeable
    run_rabbitmqctl('stop_app')
    change_cluster_node_type(_cluster_node_type)
    run_rabbitmqctl('start_app')
    Chef::Log.info("[rabbitmq_cluster] The cluster node type of #{_node_name} has been changed into #{_cluster_node_type}")
    Chef::Log.info("#{cluster_status}")
  end
end
