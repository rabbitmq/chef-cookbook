# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Provider:: erlang_yum_repository_on_cloudsmith
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

provides :erlang_repository, platform_family: %w(suse)

default_action :create

property :baseurl, String, required: true

property :gpgcheck, [true, false], default: true
property :gpgkey, String
property :gpgautoimportkeys, [true, false], default: true

property :enabled, [true, false], default: true
property :priority, Integer

action :create do
  execute 'zypper refresh' do
    command 'zypper --gpg-auto-import-keys refresh'
    # triggered by a notification
    action :nothing
  end

  zypper_repository(new_resource.name) do
    description 'Erlang RPM packages from SUSE'

    baseurl new_resource.baseurl
    gpgcheck new_resource.gpgcheck
    gpgkey new_resource.gpgkey if new_resource.gpgkey
    gpgautoimportkeys new_resource.gpgautoimportkeys

    autorefresh true

    enabled new_resource.enabled
    priority new_resource.priority if new_resource.priority

    notifies :run, 'execute[zypper refresh]', :immediately

    action :create
  end
end

action :remove do
  zypper_repository(new_resource.name) do
    action :remove
  end
end
