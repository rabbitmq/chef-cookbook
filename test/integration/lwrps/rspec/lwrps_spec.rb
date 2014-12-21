require 'spec_helper'

describe command('rabbitmqadmin --version') do
  it { should return_exit_status 0 }
end

describe command('rabbitmqctl list_policies') do
  its(:stdout) { should match /\/\s+rabbitmq_cluster\s+queues\s+cluster\.\*\s+{"ha-mode":"all","ha-sync-mode":"automatic"}\s+0/ } # rubocop:disable all
end
