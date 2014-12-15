require 'spec_helper'

describe 'rabbitmq::default' do
  version = '3.4.2-1'

  let(:chef_run) do
    ChefSpec::ServerRunner.new.converge(described_recipe)
  end

  let(:file_cache_path) { Chef::Config[:file_cache_path] }

  it 'creates a directory for mnesiadir' do
    expect(chef_run).to create_directory('/var/lib/rabbitmq/mnesia')
  end

  it 'creates a template rabbitmq-env.conf with attributes' do
    expect(chef_run).to create_template('/etc/rabbitmq/rabbitmq-env.conf').with(
      :user => 'root',
      :group => 'root',
      :source => 'rabbitmq-env.conf.erb',
      :mode => 00644)
  end

  it 'should create the directory /var/lib/rabbitmq/mnesia' do
    expect(chef_run).to create_directory('/var/lib/rabbitmq/mnesia').with(
     :user => 'rabbitmq',
     :group => 'rabbitmq',
     :mode => '775'
   )
  end

  it 'enables a rabbitmq service' do
    expect(chef_run).to enable_service('rabbitmq-server')
  end

  it 'start a rabbitmq service' do
    expect(chef_run).to start_service('rabbitmq-server')
  end

  it 'creates a rabbitmq-server rpm in the cache path' do
    expect(chef_run).to create_remote_file_if_missing("#{Chef::Config[:file_cache_path]}/rabbitmq-server-#{version}.noarch.rpm")
  end

  it 'installs the rabbitmq-server rpm_package with the default action' do
    expect(chef_run).to install_rpm_package("#{Chef::Config[:file_cache_path]}/rabbitmq-server-#{version}.noarch.rpm")
  end

  it 'creates a template rabbitmq.config with attributes' do
    expect(chef_run).to create_template('/etc/rabbitmq/rabbitmq.config').with(
      :user => 'root',
      :group => 'root',
      :source => 'rabbitmq.config.erb',
      :mode => 00644)
  end
end
