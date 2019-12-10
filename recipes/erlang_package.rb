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
#     https://www.apache.org/licenses/LICENSE-2.0
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

if platform_family?('debian')
  rabbitmq_erlang_apt_repository_on_bintray 'rabbitmq_erlang_repo_on_bintray' do
    uri node['rabbitmq']['erlang']['apt']['uri'] unless node['rabbitmq']['erlang']['apt']['uri'].nil?
    distribution node['rabbitmq']['erlang']['apt']['lsb_codename'] if node['rabbitmq']['erlang']['apt']['lsb_codename']
    components node['rabbitmq']['erlang']['apt']['components']
    key node['rabbitmq']['erlang']['apt']['key']
    action :add
  end

  rabbitmq_erlang_package_from_bintray 'rabbitmq_erlang' do
    use_hipe node['rabbitmq']['erlang']['hipe']
    version erlang_version unless erlang_version.nil?

    options node['rabbitmq']['erlang']['apt']['install_options'] unless node['rabbitmq']['erlang']['apt']['install_options'].nil?
    retry_delay node['rabbitmq']['erlang']['retry_delay'] unless node['rabbitmq']['erlang']['retry_delay'].nil?
  end
end

if platform_family?('rhel')
  if node['platform_version'].to_i <= 5
    Chef::Log.fatal('RabbitMQ package repositories are not available for EL5')
    raise
  end
end

if platform_family?('rhel', 'fedora', 'amazon')
  rabbitmq_erlang_yum_repository_on_bintray 'rabbitmq_erlang' do
    baseurl node['rabbitmq']['erlang']['yum']['baseurl']
    gpgkey node['rabbitmq']['erlang']['yum']['gpgkey']
    gpgcheck node['rabbitmq']['erlang']['yum']['gpgcheck']
    repo_gpgcheck node['rabbitmq']['erlang']['yum']['repo_gpgcheck']
    enabled true
  end

  rabbitmq_erlang_package_from_bintray 'rabbitmq_erlang' do
    version erlang_version unless erlang_version.nil?

    retry_delay node['rabbitmq']['erlang']['retry_delay'] unless node['rabbitmq']['erlang']['retry_delay'].nil?
  end
end

if platform_family?('suse')
  rabbitmq_erlang_zypper_repository_on_suse_factory 'rabbitmq_erlang' do
    baseurl node['rabbitmq']['erlang']['zypper']['baseurl']
    gpgkey node['rabbitmq']['erlang']['zypper']['gpgkey']
    gpgcheck node['rabbitmq']['erlang']['zypper']['gpgcheck']
    gpgautoimportkeys node['rabbitmq']['erlang']['zypper']['gpgautoimportkeys']
    enabled true
  end

  rabbitmq_erlang_package_from_bintray 'rabbitmq_erlang' do
    version erlang_version unless erlang_version.nil?

    retry_delay node['rabbitmq']['erlang']['retry_delay'] unless node['rabbitmq']['erlang']['retry_delay'].nil?
  end
end
