# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Resource:: erlang_apt_repository_on_cloudsmith
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

default_action :add

property :uri, String, default: ''
property :distribution, String
property :components, Array, default: ['erlang']
property :key, String, default: ''
property :keyserver, String

property :trusted, [true, false], default: false

provides :erlang_repository, platform_family: %w(debian)

action :add do
  package 'apt-transport-https'

  apt_repository(new_resource.name) do
    uri new_resource.uri
    distribution new_resource.distribution if new_resource.distribution
    components new_resource.components
    key new_resource.key
    keyserver new_resource.keyserver if new_resource.keyserver
    trusted new_resource.trusted

    action :add
  end

  apt_preference(new_resource.name) do
    glob 'erlang*'
    pin 'release o=cloudsmith'
    pin_priority '800'

    action :add
  end
end

action :remove do
  apt_repository(new_resource.name) do
    action :remove
  end

  apt_preference(new_resource.name) do
    action :remove
  end
end
