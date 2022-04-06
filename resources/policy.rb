# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Resource:: policy
#
# Author: Robert Choi <taeilchoi1@gmail.com>
# Copyright 2013 by Robert Choi
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

include RabbitMQ::CoreHelpers

unified_mode true if respond_to?(:unified_mode)

default_action :set

property :policy, String, name_property: true
property :pattern, String
property :definition, Hash
property :priority, Integer, default: 0
property :apply_to, String, :equal_to => %w(all queues exchanges), default: 'all'
property :vhost, String, default: '/'

deprecated_property_alias 'parameters',
                          'definition',
                          'The \"parameters\" property has been renamed \"definition\". '\
                          'Please update your cookbooks to use the new property name.'

load_current_value do |new_resource|
  p = get_policy(new_resource.policy, new_resource.vhost)

  current_value_does_not_exist! unless p

  pattern p['pattern']
  definition p['definition']
  apply_to p['apply-to']
  priority p['priority']
end

action :set do
  # These properties are only required for the :set action
  [:pattern, :definition].each do |prop|
    raise(
      Chef::Exceptions::ValidationFailed,
      "#{prop} is a required property"
    ) unless property_is_set?(prop)
  end

  converge_if_changed do
    cmd = "rabbitmqctl -q set_policy -p #{new_resource.vhost}"
    cmd += " --apply-to #{new_resource.apply_to}"
    cmd += " #{new_resource.policy}"
    cmd += " \"#{new_resource.pattern}\""
    cmd += " '#{new_resource.definition.to_json}'"
    cmd += " --priority #{new_resource.priority}"

    execute "set_policy #{new_resource.policy} on vhost #{new_resource.vhost}" do
      command cmd
      environment shell_environment
    end
  end
end

action :clear do
  execute "clear_policy #{new_resource.policy} from vhost #{new_resource.vhost}" do
    command "rabbitmqctl clear_policy #{new_resource.policy} -p #{new_resource.vhost}"
    environment shell_environment
    only_if { get_policy(new_resource.policy, new_resource.vhost) }
  end
end
