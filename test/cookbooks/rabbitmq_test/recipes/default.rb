# frozen_string_literal: true
#
# Cookbook:: rabbitmq_test
# Recipe:: default
#
# Copyright:: 2012-2017, Chef Software, Inc. <legal@chef.io>
# Copyright:: 2017-2019, Pivotal Software, Inc. <info@rabbitmq.com>
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

apt_update if platform_family?('debian')

chef_gem 'bunny' do
  action :install
end

include_recipe 'rabbitmq::default'

# HACK: Give rabbit time to spin up before the tests, it seems
# to be responding that it has started before it really has
execute 'sleep 15' do
  action :nothing
  subscribes :run, "service[#{node['rabbitmq']['service_name']}]", :delayed
end
