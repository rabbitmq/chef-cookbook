# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Resource:: user
#
# Copyright 2011-2019, Chef Software, Inc.
# Copyright 2019-2021, VMware, Inc or its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

unified_mode true if respond_to?(:unified_mode)

default_action :add

property :user, String, name_property: true
property :password, String
property :vhost, [String, Array], default: '/', coerce: proc { |x| [x].flatten }
property :permissions, String
property :tag, String

action_class do
  include RabbitMQ::CoreHelpers

  def user_exists?(name)
    cmd = "rabbitmqctl -s list_users |grep '^#{name}\\s'"
    cmd = Mixlib::ShellOut.new(cmd, :env => shell_environment)
    cmd.run_command
    Chef::Log.debug "rabbitmq_user_exists?: #{cmd}"
    Chef::Log.debug "rabbitmq_user_exists?: #{cmd.stdout}"
    !cmd.error?
  end

  def user_has_tag?(name, tag)
    cmd = 'rabbitmqctl -s list_users'
    cmd = Mixlib::ShellOut.new(cmd, :env => shell_environment)
    cmd.run_command
    user_list = cmd.stdout
    tags = user_list.match(/^#{name}\s+\[(.*?)\]/)[1].split
    Chef::Log.debug "rabbitmq_user_has_tag?: #{cmd}"
    Chef::Log.debug "rabbitmq_user_has_tag?: #{cmd.stdout}"
    Chef::Log.debug "rabbitmq_user_has_tag?: #{name} has tags: #{tags}"
    if tag.nil? && tags.empty?
      true
    elsif tags.include?(tag)
      true
    else
      false
    end
  rescue RuntimeError
    false
  end

  # does the user have the rights listed on the vhost?
  # empty perm_list means we're checking for any permissions
  def user_has_expected_permissions?(name, vhost, perm_list = nil)
    cmd = "rabbitmqctl -s list_user_permissions #{name} | grep \"^#{vhost}\\s\""
    cmd = Mixlib::ShellOut.new(cmd, :env => shell_environment)
    cmd.run_command
    Chef::Log.debug "rabbitmq_user_has_expected_permissions?: #{cmd}"
    Chef::Log.debug "rabbitmq_user_has_expected_permissions?: #{cmd.stdout}"
    Chef::Log.debug "rabbitmq_user_has_expected_permissions?: #{cmd.exitstatus}"
    # no permissions found and none expected
    if perm_list.nil? && cmd.stdout.empty?
      Chef::Log.debug 'rabbitmq_user_has_expected_permissions?: no permissions found'
      return true
    end
    # existing match search
    if perm_list == %(\"#{cmd.stdout}\").undump.split.drop(1)
      Chef::Log.debug 'rabbitmq_user_has_expected_permissions?: matching permissions already found'
      return true
    end
    Chef::Log.debug 'rabbitmq_user_has_expected_permissions?: permissions found but do not match'
    false
  end
end

action :add do
  raise(
    Chef::Exceptions::ValidationFailed,
    'password is a required property'
  ) unless property_is_set?(:password)

  # To escape single quotes in a shell, you have to close the surrounding single quotes, add
  # in an escaped single quote, and then re-open the original single quotes.
  # Since this string is interpolated once by ruby, and then a second time by the shell, we need
  # to escape the escape character ('\') twice.  This is why the following is such a mess
  # of leaning toothpicks:
  new_password = new_resource.password.gsub("'", "'\\\\''")
  cmd = "rabbitmqctl -q add_user #{new_resource.user} '#{new_password}'"
  execute "rabbitmqctl -q add_user #{new_resource.user}" do
    sensitive true if Gem::Version.new(Chef::VERSION.to_s) >= Gem::Version.new('11.14.2')
    command cmd
    environment shell_environment
    Chef::Log.info "Adding RabbitMQ user '#{new_resource.user}'."
    not_if { user_exists?(new_resource.user) }
  end
end

action :delete do
  cmd = "rabbitmqctl -q delete_user #{new_resource.user}"
  execute cmd do
    environment shell_environment
    Chef::Log.info "Deleting RabbitMQ user '#{new_resource.user}'."
    only_if { user_exists?(new_resource.user) }
  end
end

action :set_permissions do
  raise("rabbitmq_user action :set_permissions fails with nonexistent '#{new_resource.user}' user.") unless user_exists?(new_resource.user)

  perm_list = new_resource.permissions.split
  # filter out vhosts for which the user already has the permissions we expect
  filtered = new_resource.vhost.reject { |vhost| user_has_expected_permissions?(new_resource.user, vhost, perm_list) }
  filtered.each do |vhost|
    cmd = "rabbitmqctl -q set_permissions -p #{vhost} #{new_resource.user} \"#{perm_list.join('" "')}\""
    execute cmd do
      environment shell_environment
      Chef::Log.info "Setting RabbitMQ user permissions for '#{new_resource.user}' on vhost #{vhost}."
    end
  end
end

action :clear_permissions do
  raise("rabbitmq_user action :clear_permissions fails with nonexistent '#{new_resource.user}' user.") unless user_exists?(new_resource.user)

  # filter out vhosts for which the user already has the permissions we expect
  filtered = new_resource.vhost.reject { |vhost| user_has_expected_permissions?(new_resource.user, vhost) }
  filtered.each do |vhost|
    cmd = "rabbitmqctl -q clear_permissions -p #{vhost} #{new_resource.user}"
    execute cmd do
      environment shell_environment
      Chef::Log.info "Clearing RabbitMQ user permissions for '#{new_resource.user}' from vhost #{vhost}."
    end
  end
end

action :set_tags do
  raise("rabbitmq_user action :set_tags fails with nonexistent '#{new_resource.user}' user.") unless user_exists?(new_resource.user)

  cmd = "rabbitmqctl -q set_user_tags #{new_resource.user} #{new_resource.tag}"
  execute cmd do
    environment shell_environment
    Chef::Log.info "Setting RabbitMQ user '#{new_resource.user}' tags '#{new_resource.tag}'"
    not_if { user_has_tag?(new_resource.user, new_resource.tag) }
  end
end

action :clear_tags do
  raise("rabbitmq_user action :clear_tags fails with nonexistent '#{new_resource.user}' user.") unless user_exists?(new_resource.user)

  cmd = "rabbitmqctl -q set_user_tags #{new_resource.user}"
  execute cmd do
    environment shell_environment
    Chef::Log.info "Clearing RabbitMQ user '#{new_resource.user}' tags."
    not_if { user_has_tag?(new_resource.user, '"\[\]"') }
  end
end

action :change_password do
  raise(
    Chef::Exceptions::ValidationFailed,
    'password is a required property'
  ) unless property_is_set?(:password)

  new_password = new_resource.password.gsub("'", "'\\\\''")
  cmd = "rabbitmqctl -q change_password #{new_resource.user} '#{new_password}'"
  execute "rabbitmqctl -q change_password #{new_resource.user}" do
    sensitive true if Gem::Version.new(Chef::VERSION.to_s) >= Gem::Version.new('11.14.2')
    command cmd
    environment shell_environment
    Chef::Log.info "Changing password for RabbitMQ user '#{new_resource.user}'."
    only_if { user_exists?(new_resource.user) }
  end
end
