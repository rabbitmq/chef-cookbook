require 'spec_helper'

describe 'rabbitmq::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs logrotate' do
    expect(chef_run).to install_package('logrotate')
  end
end
