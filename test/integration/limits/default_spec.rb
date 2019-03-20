# The Inspec reference, with examples and extensive documentation, can be
# found at https://inspec.io/docs/reference/resources/

describe package('rabbitmq-server') do
  it { should be_installed }
end

describe service('rabbitmq-server') do
  it { should be_running }
end

describe command('HOSTNAME=$(hostname) rabbitmq-diagnostics ping') do
  its(:exit_status) { should eq 0 }
end
describe file('/etc/systemd/system/rabbitmq-server.service.d/limits.conf') do
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }

  its('content') { should match(/LimitNOFILE=54000/) }
end

describe file('/etc/rabbitmq/rabbitmq.config') do
  it { should be_file }
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
end
