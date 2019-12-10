# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Provider:: erlang_apt_repository_on_bintray
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

provides :erlang_repository, platform_family: %w(debian)

action :add do
  package 'apt-transport-https'

  apt_repository(new_resource.name) do
    uri new_resource.uri unless new_resource.uri.nil?
    distribution new_resource.distribution unless new_resource.distribution.nil?
    components new_resource.components
    key new_resource.key unless new_resource.key.nil?
    keyserver new_resource.keyserver unless new_resource.keyserver.nil?
    trusted new_resource.trusted unless new_resource.trusted.nil?

    action :add
  end

  apt_preference(new_resource.name) do
    glob 'erlang*'
    pin 'release o=Bintray'
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
