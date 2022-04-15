# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Resource:: parameter
#
# Author: Sean Porter <portertech@gmail.com>
# Copyright 2015 by Sean Porter
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

default_action :set

property :parameter, String, name_property: true
property :component, String
property :vhost, String, default: '/'
property :parameters, [Hash, Array], default: {}

action_class do
  include RabbitMQ::CoreHelpers

  def parameter_exists?(vhost, name)
    cmd = 'rabbitmqctl list_parameters -s'
    cmd += " -p #{Shellwords.escape vhost}" unless vhost.nil?
    cmd += " |grep '#{name}\\b'"

    cmd = Mixlib::ShellOut.new(cmd, :env => shell_environment)
    cmd.run_command
    !cmd.error?
  end
end

action :set do
  cmd = 'rabbitmqctl set_parameter -q'
  cmd += " -p #{new_resource.vhost}"
  cmd += " #{new_resource.component}"
  cmd += " #{new_resource.parameter}"

  cmd += " '"
  cmd += JSON.dump(new_resource.parameters)
  cmd += "'"

  parameter = "#{new_resource.component} #{new_resource.parameter}"

  execute "set_parameter #{parameter}" do
    command cmd
    environment shell_environment
    not_if { parameter_exists?(new_resource.vhost, new_resource.parameter) }
  end

  Chef::Log.info "Done setting RabbitMQ parameter #{parameter}."
end

action :clear do
  parameter = "#{new_resource.component} #{new_resource.parameter}"

  cmd = "rabbitmqctl clear_parameter #{parameter} -q -p #{new_resource.vhost}"
  execute "clear_parameter #{parameter}" do
    command cmd
    environment shell_environment
    only_if { parameter_exists?(new_resource.vhost, new_resource.parameter) }
  end

  Chef::Log.info "Done clearing RabbitMQ parameter #{parameter}."
end
