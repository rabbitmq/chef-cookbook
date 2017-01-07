# frozen_string_literal: true
require 'spec_helper'

describe package('rabbitmq-server') do
  it { should be_installed }
end

if os[:family] == 'redhat'
  describe service('rabbitmq-server') do
    it { should be_enabled }
  end
elsif %w(debian ubuntu).include?(os[:family])
  describe service('rabbitmq-server') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(5672) do
    it { should be_listening }
  end

  describe command('rabbitmqctl status') do
    it { should return_exit_status 0 }
  end
end

describe file('/var/lib/rabbitmq/mnesia') do
  it { should be_directory }
  it { should be_mode 775 }
  it { should be_owned_by 'rabbitmq' }
  it { should be_grouped_into 'rabbitmq' }
end

describe file('/etc/rabbitmq/rabbitmq-env.conf') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/etc/rabbitmq/rabbitmq.config') do
  it { should be_file }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end
