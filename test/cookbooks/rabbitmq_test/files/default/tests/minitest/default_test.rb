#
# Copyright 2012-2013, Opscode, Inc.
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

require File.expand_path('../support/helpers', __FILE__)

describe "rabbitmq_test::default" do
  include Helpers::RabbitMQ

  # it 'uses the rabbitmq apt source on debian family' do
  #   unless node['platform_family'] == 'debian'
  #     skip "Only applicable on Debian family"
  #   end

  #   file("/etc/apt/sources.list.d/rabbitmq-source.list").must_exist
  # end

  # it 'installs the package from downloaded rpm on rhel/fedora family' do
  #   unless node['platform_family'] == 'rhel' || node['platform_family'] == 'fedora'
  #     skip "Only applicable on RHEL/Fedora family"
  #   end

  #   rpm_path = "#{Chef::Config[:file_cache_path]}/rabbitmq-server-#{node['rabbitmq']['version']}-1.noarch.rpm"

  #   file(rpm_path).must_exist
  # end

  #packages
  it 'installs the rabbitmq-server package' do
    if node['rabbitmq']['use_distro_version']
      package('rabbitmq-server').must_be_installed
    else
      package('rabbitmq-server').must_be_installed.with(:version, '3.1.5-1')
    end
  end

  #directories
  it 'creates the mnesia directory' do
    directory(node['rabbitmq']['mnesiadir']).must_have(:mode, '775').with(:owner, 'rabbitmq').and(:group, 'rabbitmq')
  end

  #file
  it 'has the correct config files' do
    file("#{node['rabbitmq']['config_root']}/rabbitmq-env.conf").must_exist.with(:owner, 'root').and(:group, 'root')
    file("#{node['rabbitmq']['config_root']}/rabbitmq.config").must_exist.with(:owner, 'root').and(:group, 'root')
  end

  # service
  it 'enables & starts the rabbitmq-server service' do
    service(node['rabbitmq']['service_name']).must_be_enabled
    service(node['rabbitmq']['service_name']).must_be_running
  end

  # accepts connections
  it 'accepts AMQP connections' do
    require 'bunny'
    b = Bunny.new( :host => "localhost",
                   :port => 5672,
                   :user => node['rabbitmq']['default_user'],
                   :pass => node['rabbitmq']['default_pass'] )
    b.start
    b.stop
  end
end
