# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Recipe:: erlang_package
#
# Provisions Erlang via RabbitMQ's own
# packages for Debian and CentOS.
#
# Copyright 2019, Pivotal Software, Inc
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

node.override['erlang']['install_method'] = nil

case node['platform_family']
when 'debian'
  package 'apt-transport-https'

  apt_repository 'rabbitmq_erlang_repo' do
    uri node['rabbitmq']['erlang']['apt']['uri']
    distribution node['rabbitmq']['erlang']['apt']['lsb_codename']
    components node['rabbitmq']['erlang']['apt']['components']
    key node['rabbitmq']['erlang']['apt']['key']
    action :add
  end

  apt_preference 'rabbitmq_erlang' do
    package_name 'erlang-dev'
    pin "version #{node['rabbitmq']['erlang']['version']}"
    pin_priority 700
    action :add
    not_if { node['rabbitmq']['erlang']['version'].nil? }
  end

  package 'erlang-dev' do
    version "1:#{node['rabbitmq']['erlang']['version']}-1" if node['rabbitmq']['erlang']['version']
  end

  %w(erlang-eldap erlang-inets erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key
     erlang-runtime-tools erlang-ssl erlang-tools erlang-xmerl).each do |p|
    package(p) do
      version "1:#{node['rabbitmq']['erlang']['version']}-1" if node['rabbitmq']['erlang']['version']
    end
  end
when 'rhel'
  if node['platform_version'].to_i <= 5
    Chef::Log.fatal('RabbitMQ package repositories are not available for EL5')
    raise
  end

  yum_repository 'rabbitmq_erlang_repo' do
    description 'Erlang RPM packages from Team RabbitMQ'

    baseurl node['rabbitmq']['erlang']['yum']['baseurl'] unless node['rabbitmq']['erlang']['yum']['baseurl'].nil?
    gpgcheck node['rabbitmq']['erlang']['yum']['gpgcheck'] unless node['rabbitmq']['erlang']['yum']['gpgcheck'].nil?
    gpgkey node['rabbitmq']['erlang']['yum']['gpgkey'] unless node['rabbitmq']['erlang']['yum']['gpgkey'].nil?

    repo_gpgcheck node['rabbitmq']['erlang']['yum']['repo_gpgcheck'] unless node['rabbitmq']['erlang']['yum']['repo_gpgcheck'].nil?
    repositoryid node['rabbitmq']['erlang']['yum']['repositoryid'] unless node['rabbitmq']['erlang']['yum']['repositoryid'].nil?
    enabled node['rabbitmq']['erlang']['yum']['enabled'] unless node['rabbitmq']['erlang']['yum']['enabled'].nil?
    priority node['rabbitmq']['erlang']['yum']['priority'] unless node['rabbitmq']['erlang']['yum']['priority'].nil?

    proxy node['rabbitmq']['erlang']['yum']['proxy'] unless node['rabbitmq']['erlang']['yum']['proxy'].nil?
    proxy_username node['rabbitmq']['erlang']['yum']['proxy_username'] unless node['rabbitmq']['erlang']['yum']['proxy_username'].nil?
    proxy_password node['rabbitmq']['erlang']['yum']['proxy_password'] unless node['rabbitmq']['erlang']['yum']['proxy_password'].nil?



    sslcacert node['rabbitmq']['erlang']['yum']['sslcacert'] unless node['rabbitmq']['erlang']['yum']['sslcacert'].nil?
    sslclientcert node['rabbitmq']['erlang']['yum']['sslclientcert'] unless node['rabbitmq']['erlang']['yum']['sslclientcert'].nil?
    sslclientkey node['rabbitmq']['erlang']['yum']['sslclientkey'] unless node['rabbitmq']['erlang']['yum']['sslclientkey'].nil?
    sslverify node['rabbitmq']['erlang']['yum']['sslverify'] unless node['rabbitmq']['erlang']['yum']['sslverify'].nil?

    timeout node['rabbitmq']['erlang']['yum']['timeout'] unless node['rabbitmq']['erlang']['yum']['timeout'].nil?

    action :create
  end

  package 'erlang' do
    version node['rabbitmq']['erlang']['version'] if node['rabbitmq']['erlang']['version']
  end
end
