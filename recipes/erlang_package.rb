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

node.default['erlang']['install_method'] = nil
node.override['erlang']['install_method'] = nil

# yum-erlang_solutions assumes that if it is loaded, you
node.default['yum']['erlang_solutions']['enabled'] = false
node.override['yum']['erlang_solutions']['enabled'] = false

erlang_version = node['rabbitmq']['erlang']['version']

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

  base_pkg = if node['rabbitmq']['erlang']['hipe']
    "erlang-base-hipe"
  else
    "erlang-base"
  end
  apt_package(base_pkg) do
    options node['rabbitmq']['erlang']['apt']['install_options']
    version erlang_version unless erlang_version.nil?
    retries 3
    retry_delay node['rabbitmq']['erlang']['retry_delay'] unless node['rabbitmq']['erlang']['retry_delay'].nil?
  end

  apt_preference "rabbitmq-#{base_pkg}" do
    package_name base_pkg
    pin "version #{erlang_version}"
    pin_priority 900
    action :add
    not_if { erlang_version.nil? }
  end

  to_install = %w(erlang-asn1 erlang-crypto erlang-public-key erlang-ssl erlang-syntax-tools
                  erlang-mnesia erlang-runtime-tools erlang-snmp erlang-os-mon erlang-parsetools
                  erlang-inets erlang-tools erlang-eldap erlang-xmerl
                  erlang-dev erlang-edoc erlang-eunit erlang-erl-docgen erlang-src)

  to_install.each do |p|
    apt_preference "rabbitmq-#{p}" do
      package_name p
      pin "version #{erlang_version}"
      pin_priority 900
      action :add
      not_if { erlang_version.nil? }
    end

    # Note: apt_resource can install multiple packages at once but not of a specific version.
    # This may be a bug in that resource. Instead of relying on pinning to happen first, install
    # packages one by one: slower but avoids implicit behavior/execution order dependency. MK.
    apt_package(p) do
      options node['rabbitmq']['erlang']['apt']['install_options']
      version erlang_version unless erlang_version.nil?

      retries 3
      retry_delay node['rabbitmq']['erlang']['retry_delay'] unless node['rabbitmq']['erlang']['retry_delay'].nil?
    end
  end
when 'rhel', 'fedora'
  if node['platform_version'].to_i <= 5
    Chef::Log.fatal('RabbitMQ package repositories are not available for EL5')
    raise
  end

  execute 'yum update' do
    command 'yum update -y'
    # triggered by a notification
    action :nothing
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

    notifies :run, 'execute[yum update]', :immediately
  end

  package 'erlang' do
    version erlang_version if erlang_version
    options %w(-y)
    retries 3
    retry_delay node['rabbitmq']['erlang']['retry_delay'] unless node['rabbitmq']['erlang']['retry_delay'].nil?
  end
end
