#
# Cookbook Name:: rabbitmq
# Recipe:: plugin_management
#
# Copyright 2013, Grégoire Seux
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

include_recipe "rabbitmq::default"

enabled_plugins = node['rabbitmq']['enabled_plugins']

enabled_plugins.each do |plugin|
  rabbitmq_plugin plugin do
    action :enable
    notifies :restart, "service[#{node['rabbitmq']['service_name']}]"
  end
end

disabled_plugins = node['rabbitmq']['disabled_plugins']

disabled_plugins.each do |plugin|
  rabbitmq_plugin plugin do
    action :disable
    notifies :restart, "service[#{node['rabbitmq']['service_name']}]"
  end
end
