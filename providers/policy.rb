#
# Cookbook Name:: rabbitmq
# Provider:: policy
#
# Copyright 2013, Hewlett-Packard Development Company, L.P.
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

action :set do
  execute "rabbitmqctl set_policy -v #{new_resource.vhost} #{new_resource.name} '#{new_resource.pattern}' '#{new_resource.definition}' #{new_resource.priority}" do
    not_if "rabbitmqctl list_policies -v #{new_resource.vhost} | grep #{new_resource.name}"
    Chef::Log.info "Adding RabbitMQ Policy '#{new_resource.name}'."
    new_resource.updated_by_last_action(true)
  end
end

action :clear do
  execute "rabbitmqctl clear_policy -v #{new_resource.vhost} #{new_resource.name}" do
    only_if "rabbitmqctl list_policies -v #{new_resource.vhost} | grep #{new_resource.name}"
    Chef::Log.info "Clearing RabbitMQ policy '#{new_resource.name}'."
    new_resource.updated_by_last_action(true)
  end
end
