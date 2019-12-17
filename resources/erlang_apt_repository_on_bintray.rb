# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Resource:: erlang_apt_repository_on_bintray
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

actions :add, :remove
default_action :add

attribute :uri, String, default: 'https://dl.bintray.com/rabbitmq-erlang/debian'
attribute :distribution, String
# Available values: 'erlang', 'erlang-21.x', 'erlang-20.x', 'erlang-19.x'
# 'erlang' means "the latest release"
attribute :components, Array, default: ['erlang'], required: true
attribute :key, String, default: '6B73A36E6026DFCA', required: true
attribute :keyserver, String

attribute :trusted, [TrueClass, FalseClass], default: false
