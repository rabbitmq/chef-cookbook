# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Resource:: erlang_yum_repository_on_cloudsmith
#
# Copyright 2019-2021, VMware, Inc. or its affiliates
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

unified_mode true if respond_to?(:unified_mode)

provides :erlang_repository, platform_family: %w(rhel fedora amazon)

default_action :create

property :baseurl, String, required: true

property :gpgcheck, [true, false], default: true
property :gpgkey, String

property :repo_gpgcheck, [true, false], default: true
property :repositoryid, String
property :enabled, [true, false], default: true
property :priority, String

property :proxy, String
property :proxy_username, String
property :proxy_password, String

property :sslcacert, String
property :sslclientcert, String
property :sslclientkey, String
property :sslverify, [true, false]

property :timeout, String

action :create do
  yum_repository(new_resource.name) do
    description 'Erlang RPM packages from Team RabbitMQ'

    baseurl new_resource.baseurl
    gpgcheck new_resource.gpgcheck
    gpgkey new_resource.gpgkey if new_resource.gpgkey

    repo_gpgcheck new_resource.repo_gpgcheck
    repositoryid new_resource.repositoryid if new_resource.repositoryid
    enabled new_resource.enabled
    priority new_resource.priority if new_resource.priority

    proxy new_resource.proxy if new_resource.proxy
    proxy_username new_resource.proxy_username if new_resource.proxy_username
    proxy_password new_resource.proxy_password if new_resource.proxy_password

    sslcacert new_resource.sslcacert if new_resource.sslcacert
    sslclientcert new_resource.sslclientcert if new_resource.sslclientcert
    sslclientkey new_resource.sslclientkey if new_resource.sslclientkey
    sslverify new_resource.sslverify if new_resource.sslverify

    timeout new_resource.timeout if new_resource.timeout

    action :create
  end
end

action :remove do
  yum_repository(new_resource.name) do
    action :remove
  end
end
