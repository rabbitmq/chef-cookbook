# frozen_string_literal: true
require 'spec_helper'

describe 'rabbitmq::policies' do
  let(:runner) { ChefSpec::ServerRunner.new(REDHAT_OPTS) }
  let(:node) { runner.node }
  let(:chef_run) do
    node.override['rabbitmq']['policies']['ha-all']['pattern'] = '^(?!amq\\.).*'
    node.override['rabbitmq']['policies']['ha-all']['params'] = { 'ha-mode' => 'all' }
    node.override['rabbitmq']['policies']['ha-all']['priority'] = 0
    node.override['rabbitmq']['policies']['ha-two']['pattern'] = '^two.'
    node.override['rabbitmq']['policies']['ha-two']['params'] = { 'ha-mode' => 'exactly', 'ha-params' => 2 }
    node.override['rabbitmq']['policies']['ha-two']['priority'] = 1
    runner.converge(described_recipe)
  end

  let(:file_cache_path) { Chef::Config[:file_cache_path] }

  it 'includes the `default` recipe' do
    expect(chef_run).to include_recipe('rabbitmq::default')
  end

  it 'sets a rabbitmq policy ha-all' do
    expect(chef_run).to set_rabbitmq_policy('ha-all')
  end

  it 'sets a rabbitmq policy ha-two' do
    expect(chef_run).to set_rabbitmq_policy('ha-two')
  end
end
