# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Recipe:: cluster
#
# Author: Sunggun Yu <sunggun.dev@gmail.com>
# Copyright 2015 Sunggun Yu
# Copyright 2013-2018, Chef Software, Inc.
# Copyright 2018-2019, Pivotal Software, Inc.
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
require 'json'

include_recipe 'rabbitmq::default'

cluster_nodes = node['rabbitmq']['clustering']['cluster_nodes']
cluster_nodes = cluster_nodes.to_json

auto_cluster_nodes = cluster_nodes
static_cluster_nodes = cluster_nodes

# Manual clustering
unless node['rabbitmq']['clustering']['use_auto_clustering']
  # Join in cluster
  rabbitmq_cluster auto_cluster_nodes do
    cluster_name node['rabbitmq']['clustering']['cluster_name']
    action :join
  end
end

# Set cluster name : It will be skipped once same cluster name has been set in the cluster.
rabbitmq_cluster static_cluster_nodes do
  cluster_name node['rabbitmq']['clustering']['cluster_name']
  action [:set_cluster_name, :change_cluster_node_type]
end
