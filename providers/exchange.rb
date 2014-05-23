#
# Cookbook Name:: rabbitmq
# Provider:: exchange
#
# Copyright 2011, Opscode, Inc.
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

require 'cgi'
require 'json'

action :add do
  vhost = CGI.escape(new_resource.vhost)
  name = CGI.escape(new_resource.exchange)
  type = new_resource.type
  auto_delete = new_resource.auto_delete
  durable = new_resource.durable
  arguments = new_resource.arguments
  post_body = {:type => type, :auto_delete => auto_delete,
               :durable => durable, :arguments => arguments}
  post = post_body.to_json
  post = post.sub("'", "\\'")
  execute "curl -L --post301 -f -u guest:guest -H 'content-type:application/json' \
    -XPUT -d'#{post}' http://localhost:15672/api/exchanges/#{vhost}/#{name}" do
    not_if "rabbitmqctl list_exchanges | grep #{new_resource.exchange}"
    Chef::Log.info "Adding RabbitMQ exchange '#{new_resource.exchange}'."
    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  vhost = CGI.escape(new_resource.vhost)
  name = CGI.escape(new_resource.exchange)
  execute "curl -L --post301 -f -u guest:guest -H 'content-type:application/json' \
    -XDELETE http://localhost:15672/api/exchanges/#{vhost}/#{name}" do
    only_if "rabbitmqctl list_exchanges | grep #{new_resource.exchange}"
    Chef::Log.info "Deleting RabbitMQ exchange '#{new_resource.exchange}'."
    new_resource.updated_by_last_action(true)
  end
end
