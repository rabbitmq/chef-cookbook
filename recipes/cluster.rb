# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Recipe:: cluster
#
# Author: Sunggun Yu <sunggun.dev@gmail.com>
# Copyright (C) 2015 Sunggun Yu
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
require 'json'

include_recipe 'rabbitmq::default'

cluster_nodes = node['rabbitmq']['clustering']['cluster_nodes']

# Only join unless classic config peer discovery is used
unless node['rabbitmq']['clustering']['use_auto_clustering']
  rabbitmq_cluster "unnamed-rabbitmq-cluster" do
    cluster_name node['rabbitmq']['clustering']['cluster_name']
    action :join
  end
end

unless node['rabbitmq']['clustering']['cluster_name']
  target_name = if cluster_nodes.any?
                  # this is what RabbitMQ would do anyway
                  cluster_nodes.first.name
                else
                  'rabbitmq-cluster'
                end

  # Set cluster name to the first node's name, if any
  rabbitmq_cluster "rabbitmq-cluster-#{target_name}" do
    cluster_name target_name
    action [:set_cluster_name, :change_cluster_node_type]
  end
end
