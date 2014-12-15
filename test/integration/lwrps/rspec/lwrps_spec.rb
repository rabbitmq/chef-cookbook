require 'spec_helper'

describe file('/usr/local/bin/rabbitmqadmin') do
  it { should be_file }
  it { should be_executable }
end

describe command('/usr/local/bin/rabbitmqadmin --version') do
  it { should return_exit_status 0 }
end

describe command('/usr/local/bin/rabbitmqctl list_policies') do
  its(:stdout) { should match /\/\s+rabbitmq_cluster\s+queues\s+cluster\.\*\s+{"ha-mode":"all","ha-sync-mode":"automatic"}\s+0/ } # rubocop:disable all
end
