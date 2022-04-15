# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Resource:: plugin
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

default_action :enable

property :plugin, String, name_property: true

action_class do
  include RabbitMQ::CoreHelpers

  def plugin_enabled?(name)
    cmdstr = "/usr/lib/rabbitmq/bin/rabbitmq-plugins list -q -e '#{name}\\b'"
    cmd = Mixlib::ShellOut.new(cmdstr, :env => shell_environment)
    cmd.run_command
    Chef::Log.debug "rabbitmq_plugin_enabled?: #{cmdstr}"
    Chef::Log.debug "rabbitmq_plugin_enabled?: #{cmd.stdout}"
    cmd.error!
    cmd.stdout =~ /\b#{name}\b/
  end
end

action :enable do
  execute "rabbitmq-plugins enable #{new_resource.plugin}" do
    command "/usr/lib/rabbitmq/bin/rabbitmq-plugins enable #{new_resource.plugin}"
    umask '0022'
    Chef::Log.info "Enabling RabbitMQ plugin '#{new_resource.plugin}'."
    environment shell_environment
    not_if { plugin_enabled?(new_resource.plugin) }
  end
end

action :disable do
  execute "rabbitmq-plugins disable #{new_resource.plugin}" do
    command "/usr/lib/rabbitmq/bin/rabbitmq-plugins disable #{new_resource.plugin}"
    umask '0022'
    Chef::Log.info "Disabling RabbitMQ plugin '#{new_resource.plugin}'."
    environment shell_environment
    only_if { plugin_enabled?(new_resource.plugin) }
  end
end
