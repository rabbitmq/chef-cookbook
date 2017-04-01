# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Provider:: policy
#
# Author: Robert Choi <taeilchoi1@gmail.com>
# Copyright 2013 by Robert Choi
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

require 'shellwords'

include Opscode::RabbitMQ

use_inline_resources

def policy_exists?(vhost, name)
  cmd = 'rabbitmqctl list_policies'
  cmd += " -p #{Shellwords.escape vhost}" unless vhost.nil?
  cmd += " |grep '#{name}\\b'"

  cmd = Mixlib::ShellOut.new(cmd, :env => shell_environment)
  cmd.run_command
  begin
    cmd.error!
    true
  rescue
    false
  end
end

action :set do
  cmd = 'rabbitmqctl set_policy'
  cmd += " -p #{new_resource.vhost}" unless new_resource.vhost.nil?
  cmd += " --apply-to #{new_resource.apply_to}" if new_resource.apply_to
  cmd += " #{new_resource.policy}"
  cmd += " \"#{new_resource.pattern}\""
  cmd += " '{"

  first_param = true
  new_resource.parameters.each do |key, value|
    cmd += ',' unless first_param

    cmd += if value.is_a? String
             "\"#{key}\":\"#{value}\""
           else
             "\"#{key}\":#{value}"
           end
    first_param = false
  end

  cmd += "}'"
  if node['rabbitmq']['version'] >= '3.2.0'
    cmd += " --priority #{new_resource.priority}" if new_resource.priority
  else
    cmd += " #{new_resource.priority}" if new_resource.priority # rubocop:disable all
  end

  execute "set_policy #{new_resource.policy}" do
    command cmd
    environment shell_environment
  end

  new_resource.updated_by_last_action(true)
  Chef::Log.info "Done setting RabbitMQ policy '#{new_resource.policy}'."
end

action :clear do
  if policy_exists?(new_resource.vhost, new_resource.policy)
    cmd = "rabbitmqctl clear_policy #{new_resource.policy}"
    cmd += " -p #{new_resource.vhost}" unless new_resource.vhost.nil?
    execute "clear_policy #{new_resource.policy}" do
      command cmd
      environment shell_environment
    end

    new_resource.updated_by_last_action(true)
    Chef::Log.info "Done clearing RabbitMQ policy '#{new_resource.policy}'."
  end
end

action :list do
  execute 'list_policies' do
    command 'rabbitmqctl list_policies'
    environment shell_environment
  end

  new_resource.updated_by_last_action(true)
end
