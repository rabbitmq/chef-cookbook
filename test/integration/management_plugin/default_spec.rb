# The Inspec reference, with examples and extensive documentation, can be
# found at https://inspec.io/docs/reference/resources/

describe package('rabbitmq-server') do
  it { should be_installed }
end

describe service('rabbitmq-server') do
  it { should be_running }
end

describe command('HOSTNAME=$(hostname) rabbitmq-plugins list -E | grep rabbitmq_management') do
  its(:exit_status) { should eq 0 }
end

describe port(5672) do
  it { should be_listening }
end

describe port(15672) do
  it { should be_listening }
end
