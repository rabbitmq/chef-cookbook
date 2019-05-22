# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq_test
# Recipe:: lwrps
#
# Copyright 2013, Chef Software, Inc. <legal@chef.io>
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

chef_gem 'bunny' do
  action :install
end

include_recipe 'rabbitmq::default'

# force the rabbitmq restart now, then start testing
execute 'sleep 10' do
  notifies :restart, "service[#{node['rabbitmq']['service_name']}]", :immediately
end

include_recipe 'rabbitmq::plugins'
include_recipe 'rabbitmq::vhosts'
include_recipe 'rabbitmq::policies'
include_recipe 'rabbitmq::users'

# can't verify it actually goes through without logging in, but at least exercise the code
rabbitmq_user 'kitchen3' do
  password 'foobar'
  action :change_password
end

rabbitmq_user 'permissionless' do
  password 'permi$$ionless'
  action :add
end

rabbitmq_user 'permissionless' do
  action :clear_permissions
end

# download the rabbitmqadmin util from management plugin
# this tests an immediate notifies statement
# see https://github.com/kennonkwok/rabbitmq/issues/141
rabbitmq_plugin 'rabbitmq_management' do
  action :enable
  notifies :restart, "service[#{node['rabbitmq']['service_name']}]", :immediately # must restart before we can download
end

rabbitmq_plugin 'rabbitmq_top' do
  action :disable
end

rabbitmq_policy 'rabbitmq_mirroring' do
  pattern 'mirroring.*'
  parameters 'ha-mode' => 'all', 'ha-sync-mode' => 'automatic'
  apply_to 'queues'
  action :set
end

rabbitmq_plugin 'rabbitmq_federation'

rabbitmq_vhost 'sensu'

rabbitmq_parameter 'sensu-dc-1' do
  vhost 'sensu'
  component 'federation-upstream'
  parameters 'uri' => 'amqp://dc-cluster-node'
end
