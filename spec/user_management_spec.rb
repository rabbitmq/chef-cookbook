require 'spec_helper'

describe 'rabbitmq::user_management' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new.converge(described_recipe)
  end

  let(:file_cache_path) { Chef::Config[:file_cache_path] }

  it 'includes the `default` recipe' do
    expect(chef_run).to include_recipe('rabbitmq::default')
  end

  it 'includes the `virtualhost_management` recipe' do
    expect(chef_run).to include_recipe('rabbitmq::virtualhost_management')
  end

end
