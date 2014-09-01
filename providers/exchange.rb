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
  vhost = new_resource.vhost
  name = new_resource.exchange
  cvhost = CGI.escape(vhost)
  cname = CGI.escape(name)
  type = new_resource.type
  auto_delete = new_resource.auto_delete
  durable = new_resource.durable
  arguments = new_resource.arguments
  post_body = { :type => type, :auto_delete => auto_delete,
                :durable => durable, :arguments => arguments }
  post = post_body.to_json
  post = post.sub("'", "\\'")
  uri = "http://localhost:15672/api/exchanges/#{cvhost}/#{cname}"
  ruby_block "Creating rabbitmq exchange #{vhost}/#{name}" do
    block do
      puri = URI.parse(uri)
      http = Net::HTTP.new(puri.host, puri.port)
      request = Net::HTTP::Put.new(puri.request_uri)
      request['Content-Type'] = 'application/json'
      request.basic_auth('guest', 'guest')
      request.body = post
      http.request(request)
    end
    not_if "rabbitmqctl list_exchanges -p '#{vhost}' | grep #{name}"
    Chef::Log.info "Adding RabbitMQ exchange '#{name}'."
    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  vhost = new_resource.vhost
  name = new_resource.exchange
  cvhost = CGI.escape(vhost)
  cname = CGI.escape(name)
  uri = "http://localhost:15672/api/exchanges/#{cvhost}/#{cname}"
  ruby_block "Deleting rabbitmq exchange #{vhost}/#{name}" do
    block do
      puri = URI.parse(uri)
      http = Net::HTTP.new(puri.host, puri.port)
      request = Net::HTTP::Delete.new(puri.request_uri)
      request['Content-Type'] = 'application/json'
      request.basic_auth('guest', 'guest')
      http.request(request)
    end
    only_if "rabbitmqctl list_exchanges -p '#{vhost}' | grep #{name}"
    Chef::Log.info "Deleting RabbitMQ exchange '#{name}'."
    new_resource.updated_by_last_action(true)
  end
end
