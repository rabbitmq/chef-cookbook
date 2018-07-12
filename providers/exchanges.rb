# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Provider:: exchanges
#
# Copyright 2011-2013, Chef Software, Inc.
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

include Opscode::RabbitMQ

use_inline_resources

def exchanges_exists?(vhost, exchange)
    cmd = "rabbitmqctl -q list_exchanges -p #{vhost}| grep #{exchange}"
    cmd = Mixlib::ShellOut.new(cmd, :env => shell_environment)
    cmd.run_command
    Chef::Log.debug "rabbitmq_exchanges_exists?: #{cmd}"
    Chef::Log.debug "rabbitmq_exchanges_exists?: #{cmd.stdout}"
    begin
        cmd.error!
        true
    rescue
        false
    end
end
action :declare do
    unless exchanges_exists?(new_resource.vhost, new_resource.exchange)
        cmd = "rabbitmqadmin -u #{new_resource.user} -p #{new_resource.password}"
        cmd += " declare exchange -V #{new_resource.vhost} name=#{new_resource.exchange}"
        cmd += " type=#{new_resource.type} durable=#{new_resource.durable} auto_delete=#{new_resource.auto_delete}"
        execute "exchange declaration #{new_resource.exchange}" do
            command cmd
            Chef::Log.debug "rabbitmq_exchanges_declare: #{cmd}"
            Chef::Log.info "Adding RabbitMQ exchanges '#{new_resource.exchange}'."
            environment shell_environment
            new_resource.updated_by_last_action(true)
        end
    end
end

action :delete do
    if exchanges_exists?(new_resource.vhost, new_resource.exchange)
        cmd = "rabbitmqadmin -u #{new_resource.user} -p #{new_resource.password}"
        cmd += " delete exchange -V #{new_resource.vhost} name=#{new_resource.exchange}"
        execute "exchange deletion #{new_resource.exchange}" do
            command cmd
            Chef::Log.debug "rabbitmq_exchange_delete: #{cmd}"
            Chef::Log.info "Deleting RabbitMQ exchange '#{new_resource.exchange}'."
            environment shell_environment
            new_resource.updated_by_last_action(true)
        end
    end
end