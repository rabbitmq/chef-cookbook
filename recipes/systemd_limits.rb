# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Recipe:: systemd_limits
#
# Configures kernel limits on systemd-based distributions
# using a systemd unit file.
# For older distributions, use a separate cookbook such as
# ulimit2.
#
# Copyright 2018, Pivotal Software, Inc
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

include_recipe 'rabbitmq::default'

directory node['rabbitmq']['systemd_unit_root'] do
  owner 'root'
  group 'root'
  mode '775'
  recursive true
end

template "#{node['rabbitmq']['systemd_unit_root']}/limits.conf" do
  source 'systemd_limits.conf.erb'
  cookbook node['rabbitmq']['config-env_template_cookbook']
  owner 'root'
  group 'root'
  mode '644'
  notifies :run,     'execute[systemctl daemon-reload]', :immediately
  notifies :restart, "service[#{node['rabbitmq']['service_name']}]"
end

execute 'systemctl daemon-reload' do
  command 'systemctl daemon-reload'

  action :nothing
  retries     3
  retry_delay 3
end
