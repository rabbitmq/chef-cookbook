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
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'json'
require 'base64'
require 'digest/sha1'

include_recipe 'rabbitmq::default'

cluster_nodes = node['rabbitmq']['clustering']['cluster_nodes']
json          = cluster_nodes.to_json

auto_cluster_hash   = Digest::SHA1.hexdigest(Base64.encode64(json))
static_cluster_hash = Digest::SHA1.hexdigest(Base64.encode64(json))

unless node['rabbitmq']['clustering']['use_auto_clustering']
  rabbitmq_cluster auto_cluster_hash do
    cluster_name cluster_name_with_fallback()
    action :join
  end
end

rabbitmq_cluster static_cluster_hash do
  cluster_name cluster_name_with_fallback()
  action [:set_cluster_name, :change_cluster_node_type]
end
