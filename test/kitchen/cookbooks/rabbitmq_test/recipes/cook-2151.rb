#
# Cookbook Name:: rabbitmq_test
# Recipe:: cook-2151
#
# Copyright 2012, Opscode, Inc. <legal@opscode.com>
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

node.set['rabbitmq']['disk_free_limit_relative'] = 1.0
node.set['rabbitmq']['vm_memory_high_watermark'] = 0.5

log "#{cookbook_name}::#{recipe_name} tests that COOK-2151 is implemented."

include_recipe "yum::epel" if node['platform_family'] == 'rhel'
include_recipe "rabbitmq::default"
