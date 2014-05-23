#
# Cookbook Name:: rabbitmq
# Provider:: exchange_binding
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
  name = new_resource.from_exchange
  dest = new_resource.destination
  cvhost = CGI.escape(vhost)
  cname = CGI.escape(name)
  cdest = CGI.escape(dest)
  type = new_resource.type
  routing_key = new_resource.routing_key
  arguments = new_resource.arguments
  post_body = { :routing_key => routing_key,
                :arguments => arguments }
  post = post_body.to_json
  post = post.sub("'", "\\'")
  uri = "http://localhost:15672/api/bindings/#{cvhost}/e/#{cname}"
  uri += (type == 'exchange') ? "/e/#{cdest}" : "/q/#{cdest}"
  ruby_block "Creating binding from #{name} to #{type} #{vhost}/#{dest}" do
    block do
      puri = URI.parse(uri)
      http = Net::HTTP.new(puri.host, puri.port)
      request = Net::HTTP::Post.new(puri.request_uri)
      request['Content-Type'] = 'application/json'
      request.basic_auth('guest', 'guest')
      request.body = post
      http.request(request)
    end
    not_if "rabbitmqctl list_bindings -p '#{vhost}' | " \
           "grep -E '^#{name}\\s+exchange\\s+#{dest}\\s+#{type}'"
    Chef::Log.info "Adding RabbitMQ binding '#{name}' to #{type} '#{dest}'."
    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  vhost = new_resource.vhost
  name = new_resource.from_exchange
  dest = new_resource.destination
  cvhost = CGI.escape(vhost)
  cname = CGI.escape(name)
  cdest = CGI.escape(dest)
  vhost = CGI.escape(new_resource.vhost)
  name = CGI.escape(new_resource.exchange)
  uri = "http://localhost:15672/api/bindings/#{cvhost}/e/#{cname}"
  uri += (type == 'exchange') ? "/e/#{cdest}" : "/q/#{cdest}"
  ruby_block "Deleting binding from #{name} to #{type} #{vhost}/#{dest}" do
    block do
      puri = URI.parse(uri)
      http = Net::HTTP.new(puri.host, puri.port)
      request = Net::HTTP::Delete.new(puri.request_uri)
      request['Content-Type'] = 'application/json'
      request.basic_auth('guest', 'guest')
      http.request(request)
    end
    only_if "rabbitmqctl list_bindings -p '#{vhost}' | " \
            "grep -E '^#{name}\\s+exchange\\s+#{dest}\\s+#{type}'"
    Chef::Log.info "Deleting RabbitMQ binding '#{name}' to #{type} '#{dest}'."
    new_resource.updated_by_last_action(true)
  end
end
