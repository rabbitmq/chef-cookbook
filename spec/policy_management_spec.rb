require 'spec_helper'

describe 'rabbitmq::policy_management' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new do |node|
      node.default['rabbitmq'] = {
        ['version'] => '3.3.5-1'
      }
    end.converge(described_recipe)
  end

  let(:file_cache_path) { Chef::Config[:file_cache_path] }

  it 'includes the `default` recipe' do
    expect(chef_run).to include_recipe('rabbitmq::default')
  end

end
