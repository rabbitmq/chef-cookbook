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
  cmd = Mixlib::ShellOut.new("rabbitmqctl -q list_users |grep '^#{name}\\b'")
  cmd.environment['HOME'] = ENV.fetch('HOME', '/root')
  cmd.run_command
  Chef::Log.debug "rabbitmq_user_exists?: rabbitmqctl -q list_users |grep '^#{name}\\b'"
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
  cmdStr = "rabbitmqctl -q list_users | grep \"^#{name}\\b\" | grep #{tag}"
  cmd = Mixlib::ShellOut.new(cmdStr)
  cmd.environment['HOME'] = ENV.fetch('HOME', '/root')
  cmd.run_command
  Chef::Log.debug "rabbitmq_user_has_tag?: rabbitmqctl -q list_users | grep \"^#{name}\\b\" | grep #{tag}"
  Chef::Log.debug "rabbitmq_user_has_tag?: #{cmd.stdout}"
  begin
    cmd.error!
    true
  rescue Exception => e
    false
  end
end

# does the user have the rights listed on the vhost?
def user_has_permissions?(name, vhost, perm_list = nil)
  cmdStr = "rabbitmqctl -q list_user_permissions #{name} | grep ^/#{vhost}\\s"
  cmd = Mixlib::ShellOut.new(cmdStr)
  cmd.environment['HOME'] = ENV.fetch('HOME', '/root')
  cmd.run_command
  Chef::Log.debug "rabbitmq_user_has_permissions?: #{cmdStr}"
  Chef::Log.debug "rabbitmq_user_has_permissions?: #{cmd.stdout}"
  Chef::Log.debug "rabbitmq_user_has_permissions?: #{cmd.exitstatus}"
  if perm_list.nil? && cmd.stdout.empty? #looking for empty and found nothing
    Chef::Log.debug "rabbitmq_user_has_permissions?: no permissions found"
    return false
  end
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
      Chef::Log.debug "rabbitmq_user_add: rabbitmqctl add_user #{new_resource.user} #{new_resource.password}"
      Chef::Log.info "Adding RabbitMQ user '#{new_resource.user}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :delete do
  if user_exists?(new_resource.user)
    execute "rabbitmqctl delete_user #{new_resource.user}" do
      Chef::Log.debug "rabbitmq_user_delete: rabbitmqctl delete_user #{new_resource.user}"
      Chef::Log.info "Deleting RabbitMQ user '#{new_resource.user}'."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :set_permissions do
  if !user_exists?(new_resource.user)
    Chef::Application.fatal!("rabbitmq_user action :set_permissions fails with non-existant '#{new_resource.user}' user.")
  end
  perm_list = new_resource.permissions.split
  unless user_has_permissions?(new_resource.user, new_resource.vhost, perm_list)
    vhostOpt = "-p #{new_resource.vhost}" unless new_resource.vhost.nil?
    execute "rabbitmqctl set_permissions #{vhostOpt} #{new_resource.user} \"#{perm_list.join("\" \"")}\"" do
      Chef::Log.fatal "rabbitmq_user_set_permissions: rabbitmqctl set_permissions #{vhostOpt} #{new_resource.user} \"#{perm_list.join("\" \"")}\""
      Chef::Log.info "Setting RabbitMQ user permissions for '#{new_resource.user}' on vhost #{new_resource.vhost}."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :clear_permissions do
  if !user_exists?(new_resource.user)
    Chef::Application.fatal!("rabbitmq_user action :clear_permissions fails with non-existant '#{new_resource.user}' user.")
  end
  # clear the permissions if they exist, empty perm_list for any permissions
  if user_has_permissions?(new_resource.user, new_resource.vhost)
    vhostOpt = "-p #{new_resource.vhost}" unless new_resource.vhost.nil?
    execute "rabbitmqctl clear_permissions #{vhostOpt} #{new_resource.user}" do
      Chef::Log.fatal "rabbitmq_user_clear_permissions: rabbitmqctl clear_permissions #{vhostOpt} #{new_resource.user}"
      Chef::Log.info "Clearing RabbitMQ user permissions for '#{new_resource.user}' from vhost #{new_resource.vhost}."
      new_resource.updated_by_last_action(true)
    end
  end
end

action :set_user_tags do
  if !user_exists?(new_resource.user)
    Chef::Application.fatal!("rabbitmq_user action :set_user_tags fails with non-existant '#{new_resource.user}' user.")
  end
  unless user_has_tag?(new_resource.user, new_resource.user_tag)
    execute "rabbitmqctl set_user_tags #{new_resource.user} #{new_resource.user_tag}" do
      Chef::Log.debug "rabbitmq_user_set_user_tags: rabbitmqctl set_user_tags #{new_resource.user} #{new_resource.user_tag}"
      Chef::Log.info "Setting RabbitMQ user '#{new_resource.user}' tags '#{new_resource.user_tag}'"
      new_resource.updated_by_last_action(true)
    end
  end
end

action :clear_user_tags do
  if !user_exists?(new_resource.user)
    Chef::Application.fatal!("rabbitmq_user action :clear_user_tags fails with non-existant '#{new_resource.user}' user.")
  end
  unless user_has_tag?(new_resource.user, '"\[\]"')
    execute "rabbitmqctl set_user_tags #{new_resource.user}" do
      Chef::Log.debug "rabbitmq_clear_user_tags: rabbitmqctl set_user_tags #{new_resource.user}"
      Chef::Log.info "Clearing RabbitMQ user '#{new_resource.user}' tags."
      new_resource.updated_by_last_action(true)
    end
  end
end
