# frozen_string_literal: true
require 'spec_helper'

describe 'rabbitmq::users' do
  let(:runner) { ChefSpec::ServerRunner.new(REDHAT_OPTS) }
  let(:node) { runner.node }
  cached(:chef_run) do
    runner.converge(described_recipe)
  end

  let(:file_cache_path) { Chef::Config[:file_cache_path] }

  it 'includes the `default` recipe' do
    expect(chef_run).to include_recipe('rabbitmq::default')
  end

  it 'includes the `virtualhost_management` recipe' do
    expect(chef_run).to include_recipe('rabbitmq::vhosts')
  end

  it 'adds rabbitmq enabled users' do
    expect(chef_run).to add_rabbitmq_user('add-guest')
  end
end
