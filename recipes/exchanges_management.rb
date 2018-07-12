# -*- coding: utf-8 -*-
# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Recipe:: exchanges_management
#
# Copyright 2013, Grégoire Seux
# Copyright 2013, Chef Software, Inc.
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

remote_file '/usr/local/bin/rabbitmqadmin' do
    source "#{node['rabbitmq']['rabbitmqadmin']['url']}"
    owner 'root'
    group 'root'
    mode '0755'
    action :create
end

node['rabbitmq']['exchanges'].each do |exchanges|
    rabbitmq_exchanges exchanges['exchange'] do
        user "#{node['rabbitmq']['rabbitmqadmin']['user']}"
        password "#{node['rabbitmq']['rabbitmqadmin']['password']}"
        vhost exchanges['vhost']
        exchange exchanges['exchange']
        type exchanges['type']
        durable exchanges['durable']
        auto_delete exchanges['auto_delete']
        action :declare
    end
end
  
node['rabbitmq']['delete_exchanges'].each do |exchanges|
    rabbitmq_exchanges exchanges['exchange'] do
        user "#{node['rabbitmq']['rabbitmqadmin']['user']}"
        password "#{node['rabbitmq']['rabbitmqadmin']['password']}"
        vhost exchanges['vhost']
        exchange exchanges['exchange']
        action :delete
    end
end