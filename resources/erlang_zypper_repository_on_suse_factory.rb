# frozen_string_literal: true
#
# Cookbook:: rabbitmq
# Resource:: erlang_zypper_repository_on_suse_factory
#
# Copyright:: 2019, Pivotal Software, Inc.
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
default_action :create

attribute :baseurl, String, required: true

property :gpgautoimportkeys, [TrueClass, FalseClass], default: true
attribute :gpgcheck, [TrueClass, FalseClass], default: false
attribute :gpgkey, String

attribute :repo_gpgcheck, [TrueClass, FalseClass], default: true
attribute :repositoryid, String
attribute :enabled, [TrueClass, FalseClass], default: true
attribute :priority, String

attribute :proxy, String
attribute :proxy_username, String
attribute :proxy_password, String

attribute :sslcacert, String
attribute :sslclientcert, String
attribute :sslclientkey, String
attribute :sslverify, [TrueClass, FalseClass]

attribute :timeout
