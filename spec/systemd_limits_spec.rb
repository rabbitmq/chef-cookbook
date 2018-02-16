# frozen_string_literal: true
require 'spec_helper'

describe 'rabbitmq::systemd_limits' do
  let(:runner) { ChefSpec::ServerRunner.new(REDHAT_OPTS) }
  let(:node) { runner.node }
  cached(:chef_run) do
    runner.converge(described_recipe)
  end
  let(:template) { chef_run.template('/etc/systemd/system/rabbitmq-server.service.d/limits.conf') }

  let(:file_cache_path) { Chef::Config[:file_cache_path] }

  it 'includes the `default` recipe' do
    expect(chef_run).to include_recipe('rabbitmq::default')
  end

  it 'creates a limits file' do
    expect(chef_run).to create_template('/etc/systemd/system/rabbitmq-server.service.d/limits.conf')
  end

  it 'reloads systemd config' do
    expect(template).to notify('execute[systemctl daemon-reload]').to(:run).immediately
  end

  it 'reloads restarts the node' do
    expect(template).to notify('service[rabbitmq-server]').to(:restart).delayed
  end
end
