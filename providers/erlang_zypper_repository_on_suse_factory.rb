# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Provider:: erlang_yum_repository_on_bintray
#
# Copyright 2019, Pivotal Software, Inc.
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

provides :erlang_repository, platform_family: %w(suse)

action :create do
  execute 'zypper refresh' do
    command 'zypper --gpg-auto-import-keys refresh'
    # triggered by a notification
    action :nothing
  end

  zypper_repository(new_resource.name) do
    description 'Erlang RPM packages from SUSE'

    baseurl new_resource.baseurl
    gpgcheck new_resource.gpgcheck unless new_resource.gpgcheck.nil?
    gpgkey new_resource.gpgkey unless new_resource.gpgkey.nil?
    gpgautoimportkeys new_resource.gpgautoimportkeys unless new_resource.gpgautoimportkeys.nil?

    autorefresh true

    repositoryid new_resource.repositoryid unless new_resource.repositoryid.nil?
    enabled new_resource.enabled unless new_resource.enabled.nil?
    priority new_resource.priority unless new_resource.priority.nil?

    proxy new_resource.proxy unless new_resource.proxy.nil?
    proxy_username new_resource.proxy_username unless new_resource.proxy_username.nil?
    proxy_password new_resource.proxy_password unless new_resource.proxy_password.nil?

    sslcacert new_resource.sslcacert unless new_resource.sslcacert.nil?
    sslclientcert new_resource.sslclientcert unless new_resource.sslclientcert.nil?
    sslclientkey new_resource.sslclientkey unless new_resource.sslclientkey.nil?
    sslverify new_resource.sslverify unless new_resource.sslverify.nil?

    timeout new_resource.timeout unless new_resource.timeout.nil?

    notifies :run, 'execute[zypper refresh]', :immediately

    action :create
  end
end

action :remove do
  zypper_repository(new_resource.name) do
    action :remove
  end
end
