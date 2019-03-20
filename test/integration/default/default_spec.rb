# The Inspec reference, with examples and extensive documentation, can be
# found at https://inspec.io/docs/reference/resources/

describe package('rabbitmq-server') do
  it { should be_installed }
end

describe service('rabbitmq-server') do
  it { should be_running }
end

# make sure HOSTNAME is set which seems not to be the case with The
# Centos 6 Docker image
describe command('HOSTNAME=$(hostname) rabbitmqctl status') do
  its(:exit_status) { should eq 0 }
end

describe command('HOSTNAME=$(hostname) rabbitmq-diagnostics ping') do
  its(:exit_status) { should eq 0 }
end

describe command('HOSTNAME=$(hostname) rabbitmq-plugins list') do
  its(:exit_status) { should eq 0 }
end

describe port(5672) do
  it { should be_listening }
end

describe file('/var/lib/rabbitmq/mnesia') do
  it { should be_directory }
  its('mode') { should cmp '0775' }
  its('owner') { should eq 'rabbitmq' }
  its('group') { should eq 'rabbitmq' }
end

describe file('/etc/rabbitmq/rabbitmq-env.conf') do
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }

  its('content') { should match(%r{CONFIG_FILE=/etc/rabbitmq/rabbitmq.config}) }
end

describe file('/etc/rabbitmq/rabbitmq.config') do
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
end
