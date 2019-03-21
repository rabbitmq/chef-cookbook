# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Recipe:: esl_erlang_package
#
# A convenience recipe for provisioning Erlang from
# Erlang Solution. Identical to `recipe[erlang::esl]`.
# Added to go with a recipe that provisions Erlang via RabbitMQ's own
# packages.
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

include_recipe 'erlang::esl'
