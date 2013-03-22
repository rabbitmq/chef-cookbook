#
# Cookbook Name:: rabbitmq
# Provider:: policy
#
# Author: Robert Choi <taeilchoi1@gmail.com>
# Copyright 2013 by Robert Choi
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

def policy_exists?(name)
  cmd = Mixlib::ShellOut.new("rabbitmqctl list_policies |grep '#{name}\\b'")
  cmd.environment['HOME'] = ENV.fetch('HOME', '/root')
  cmd.run_command
  begin
    cmd.error!
    true
  rescue
    false
  end
end

action :set do
  unless policy_exists?(new_resource.policy)
    cmd = "rabbitmqctl set_policy"
    cmd << " #{new_resource.policy}"
    cmd << " #{new_resource.pattern}"
    cmd << " #{new_resource.params}"

    e = execute "set_policy #{new_resource.policy}" do
      command cmd
    end

    new_resource.updated_by_last_action(e.updated?)
    if e.updated?
      Chef::Log.info "Done setting RabbitMQ policy '#{new_resource.policy}'."
    end
  end
end

action :clear do
  if policy_exists?(new_resource.policy)
    e = execute "clear_policy #{new_resource.policy}" do
      command "rabbitmqctl clear_policy #{new_resource.policy}"
    end

    new_resource.updated_by_last_action(e.updated?)
    if e.updated?
      Chef::Log.info "Done clearing RabbitMQ policy '#{new_resource.policy}'."
    end
  end
end

action :list do
  e = execute "list_policies" do
    command "rabbitmqctl list_policies"
    Chef::Log.info "Listing RabbitMQ policies."
  end
  new_resource.updated_by_last_action(e.updated?)
end
