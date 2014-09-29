require 'spec_helper'

describe file('/usr/local/bin/rabbitmqadmin') do
  it { should be_file }
  it { should be_executable }
end

describe command('/usr/local/bin/rabbitmqadmin --version') do
  it { should return_exit_status 0 }
end
