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

provides :erlang_package_from_bintray, platform_family: %w(debian rhel fedora)

DEBIAN_PACKAGES = %w(erlang-mnesia erlang-runtime-tools erlang-asn1 erlang-crypto erlang-public-key erlang-ssl
                     erlang-syntax-tools erlang-snmp erlang-os-mon erlang-parsetools
                     erlang-ftp erlang-tftp erlang-inets erlang-tools erlang-eldap erlang-xmerl
                     erlang-dev erlang-edoc erlang-eunit erlang-erl-docgen erlang-src).freeze

action :install do
  if platform_family?('debian')
    base_pkg = if new_resource.use_hipe
      'erlang-base-hipe'
    else
      'erlang-base'
    end

    erlang_packages = [base_pkg] + DEBIAN_PACKAGES

    # xenial does not have these packages
    if node['rabbitmq']['erlang']['apt']['lsb_codename'] == 'xenial'
      erlang_packages -= %w(erlang-ftp erlang-tftp)
    end

    unless new_resource.version.nil?
      erlang_packages.each do |p|
        apt_preference "#{new_resource.name}-#{p}" do
          package_name p
          pin "version #{new_resource.version}"
          pin_priority '900'
          action :add
          not_if { new_resource.version.nil? }
        end
      end
    end

    apt_package(erlang_packages) do
      options new_resource.options unless new_resource.options.nil?
      # must provide an array of versions!
      version erlang_packages.map { new_resource.version } unless new_resource.version.nil?
      retries new_resource.retries
      retry_delay new_resource.retry_delay unless new_resource.retry_delay.nil?
      action :install
    end
  end

  if platform_family?('rhel', 'fedora', 'amazon')
    package new_resource.name do
      package_name 'erlang'
      version new_resource.version unless new_resource.version.nil?
      options '-y'
      retries new_resource.retries
      retry_delay new_resource.retry_delay unless new_resource.retry_delay.nil?
    end
  end
end

action :remove do
  if platform_family?('debian')
    base_pkg = if new_resource.use_hipe
      'erlang-base-hipe'
    else
      'erlang-base'
    end

    erlang_packages = [base_pkg] + DEBIAN_PACKAGES

    # xenial does not have these packages
    if node['rabbitmq']['erlang']['apt']['lsb_codename'] == 'xenial'
      erlang_packages -= %w(erlang-ftp erlang-tftp)
    end

    erlang_packages.each do |p|
      apt_preference "#{new_resource.name}-#{p}" do
        action :remove
        not_if { new_resource.version.nil? }
      end
    end

    apt_package(erlang_packages) do
      options new_resource.options unless new_resource.options.nil?
      # must provide an array of versions!
      version erlang_packages.map { new_resource.version } unless new_resource.version.nil?
      retries new_resource.retries
      retry_delay new_resource.retry_delay unless new_resource.retry_delay.nil?
      action :remove
    end
  end

  if platform_family?('rhel', 'fedora', 'amazon')
    package new_resource.name do
      action :remove
    end
  end
end
