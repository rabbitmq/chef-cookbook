#
# Cookbook Name:: rabbitmq
# Provider:: user
#
# Copyright 2011-2013, Opscode, Inc.
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

def user_exists?(name)
  cmd = Mixlib::ShellOut.new("rabbitmqctl list_users |grep '^#{name}\\b'")
  cmd.environment['HOME'] = ENV.fetch('HOME', '/root')
  cmd.run_command
  Chef::Log.debug "rabbitmq_user_exists?: rabbitmqctl list_users |grep '^#{name}\\b'"
  Chef::Log.debug "rabbitmq_user_exists?: #{cmd.stdout}"
  begin
    cmd.error!
    true
  rescue
    false
  end
end

def user_has_tag?(name, tag)
  tag = '"\[\]"' if tag.nil?
  cmdStr = "rabbitmqctl list_users | grep \"^#{name}\\b\" | grep #{tag}"
  cmd = Mixlib::ShellOut.new(cmdStr)
  cmd.environment['HOME'] = ENV.fetch('HOME', '/root')
  cmd.run_command
  Chef::Log.fatal "rabbitmq_user_has_tag?: rabbitmqctl list_users | grep \"^#{name}\\b\" | grep #{tag}"
  Chef::Log.fatal "rabbitmq_user_has_tag?: #{cmd.stdout}"
  begin
    cmd.error!
    true
  rescue Exception => e
    false
  end
end

def user_has_rights?(vhost,name,perm_list)
  if vhost.nil?
    cmdStr = "rabbitmqctl list_permissions | grep \"^#{name}\\b\""
  else
    cmdStr = "rabbitmqctl list_permissions -p  #{vhost} | grep \"^#{name}\\b\""
  end
  cmd = Mixlib::ShellOut.new(cmdStr)
  cmd.environment['HOME'] = ENV.fetch('HOME', '/root')
  cmd.run_command
  Chef::Log.fatal "rabbitmq_user_has_rights?: #{cmdStr}"
  Chef::Log.fatal "rabbitmq_user_has_rights?: #{cmd.stdout}"
  begin
    cmd.error!
    current_permissions = cmd.stdout.each_line.first.split.drop(1)
    Chef::Log.info "Rights for #{name} are #{current_permissions} (we want #{perm_list})"
    current_permissions == perm_list
  rescue Exception => e
    Chef::Log.warn "User has probably no right on that virtual host: #{e}"
    false
  end
end


action :add do
  unless user_exists?(new_resource.user)
    if new_resource.password.nil? || new_resource.password.empty?
      Chef::Application.fatal!("rabbitmq_user with action :add requires a non-nil/empty password.")
    end
    execute "rabbitmqctl add_user #{new_resource.user} #{new_resource.password}" do
      Chef::Log.fatal "rabbitmq_user_add: rabbitmqctl add_user #{new_resource.user} #{new_resource.password}"
      Chef::Log.info "Adding RabbitMQ user '#{new_resource.user}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :delete do
  if user_exists?(new_resource.user)
    execute "rabbitmqctl delete_user #{new_resource.user}" do
      Chef::Log.fatal "rabbitmq_user_delete: rabbitmqctl delete_user #{new_resource.user}"
      Chef::Log.info "Deleting RabbitMQ user '#{new_resource.user}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :set_permissions do
  perm_list = new_resource.permissions.split
  unless user_has_rights?(new_resource.vhost, new_resource.user, perm_list)
    vhostOpt = "-p #{new_resource.vhost}" unless new_resource.vhost.nil?
    execute "rabbitmqctl set_permissions #{vhostOpt} #{new_resource.user} \"#{perm_list.join("\" \"")}\"" do
      Chef::Log.fatal "rabbitmq_user_set_permissions: rabbitmqctl set_permissions #{vhostOpt} #{new_resource.user} \"#{perm_list.join("\" \"")}\""
      Chef::Log.info "Setting RabbitMQ user permissions for '#{new_resource.user}' on vhost #{new_resource.vhost}."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :clear_permissions do
  Chef::Log.fatal "rabbitmq_user_clear_permissions only_if: rabbitmqctl list_user_permissions | grep #{new_resource.user}"
  if new_resource.vhost
    execute "rabbitmqctl clear_permissions -p #{new_resource.vhost} #{new_resource.user}" do
      Chef::Log.fatal "rabbitmq_user_clear_permissions: rabbitmqctl clear_permissions -p #{new_resource.vhost} #{new_resource.user}"
      only_if "rabbitmqctl list_user_permissions | grep #{new_resource.user}"
      Chef::Log.info "Clearing RabbitMQ user permissions for '#{new_resource.user}' from vhost #{new_resource.vhost}."
      new_resource.updated_by_last_action(true)
    end
  else
    execute "rabbitmqctl clear_permissions #{new_resource.user}" do
      Chef::Log.fatal "rabbitmq_user_clear_permissions: rabbitmqctl clear_permissions #{new_resource.user}"
      only_if "rabbitmqctl list_user_permissions | grep #{new_resource.user}"
      Chef::Log.info "Clearing RabbitMQ user permissions for '#{new_resource.user}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :set_user_tags do
  unless user_has_tag?(new_resource.user, new_resource.user_tag)
    execute "rabbitmqctl set_user_tags #{new_resource.user} #{new_resource.user_tag}" do
      Chef::Log.fatal "rabbitmq_user_set_user_tags: rabbitmqctl set_user_tags #{new_resource.user} #{new_resource.user_tag}"
      Chef::Log.info "Setting RabbitMQ user tag '#{new_resource.user_tag}' on '#{new_resource.user}'"
      new_resource.updated_by_last_action(true)
    end
  end
end
