# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Provider:: erlang_package_from_bintray
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

use_inline_resources if defined?(:use_inline_resources) # ~FC113

provides :erlang_package_from_bintray, platform_family: %w(debian ubuntu rhel centos fedora)

DEBIAN_PACKAGES = %w(erlang-asn1 erlang-crypto erlang-public-key erlang-ssl erlang-syntax-tools
                     erlang-mnesia erlang-runtime-tools erlang-snmp erlang-os-mon erlang-parsetools
                     erlang-inets erlang-tools erlang-eldap erlang-xmerl
                     erlang-dev erlang-edoc erlang-eunit erlang-erl-docgen erlang-src)

action :install do
  if platform_family?('debian', 'ubuntu')
    base_pkg = if new_resource.use_hipe
      'erlang-base-hipe'
    else
      'erlang-base'
    end
    apt_package "#{new_resource.name}-#{base_pkg}" do
      options new_resource.options unless new_resource.options.nil?
      package_name base_pkg
      version new_resource.version unless new_resource.version.nil?
      retries new_resource.retries
      retry_delay new_resource.retry_delay unless new_resource.retry_delay.nil?

      action :install
    end

    apt_preference "#{new_resource.name}-#{base_pkg}" do
      package_name base_pkg
      pin "version #{new_resource.version}"
      pin_priority 900

      action :add
      not_if { new_resource.version.nil? }
    end

    DEBIAN_PACKAGES.each do |p|
      apt_preference "#{new_resource.name}-#{p}" do
        package_name p
        pin "version #{new_resource.version}"
        pin_priority 900
        action :add
        not_if { new_resource.version.nil? }
      end

      # Note: apt_resource can install multiple packages at once but not of a specific version.
      # This may be a bug in that resource. Instead of relying on pinning to happen first, install
      # packages one by one: slower but avoids implicit behavior/execution order dependency. MK.
      apt_package(p) do
        options new_resource.options unless new_resource.options.nil?
        version new_resource.version unless new_resource.version.nil?
        retries new_resource.retries
        retry_delay new_resource.retry_delay unless new_resource.retry_delay.nil?

        action :install
      end
    end # DEBIAN_PACKAGES
  end

  if platform_family?('rhel', 'centos', 'fedora')
    package new_resource.name do
      package_name 'erlang'
      version new_resource.version unless new_resource.version.nil?
      options %w(-y)
      retries new_resource.retries
      retry_delay new_resource.retry_delay unless new_resource.retry_delay.nil?
    end
  end
end

action :remove do
  if platform_family?('debian', 'ubuntu')
    base_pkg = if new_resource.use_hipe
      'erlang-base-hipe'
    else
      'erlang-base'
    end

    apt_package "#{new_resource.name}-#{base_pkg}" do
      options new_resource.options unless new_resource.options.nil?

      action :remove
    end

    apt_preference "#{new_resource.name}-#{base_pkg}" do
      action :remove
      not_if { new_resource.version.nil? }
    end

    DEBIAN_PACKAGES.each do |p|
      apt_preference "#{new_resource.name}-#{p}" do
        action :remove
        not_if { new_resource.version.nil? }
      end

      # Note: apt_resource can install multiple packages at once but not of a specific version.
      # This may be a bug in that resource. Instead of relying on pinning to happen first, install
      # packages one by one: slower but avoids implicit behavior/execution order dependency. MK.
      apt_package "#{new_resource.name}-#{p}" do
        options new_resource.options unless new_resource.options.nil?

        action :remove
      end
    end # DEBIAN_PACKAGES

    if platform_family?('rhel', 'centos', 'fedora')
      package new_resource.name do
        action :remove
      end
    end
  end
end
