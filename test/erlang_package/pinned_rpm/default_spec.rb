# The Inspec reference, with examples and extensive documentation, can be
# found at https://inspec.io/docs/reference/resources/

describe package('erlang') do
  it { should be_installed }
  its('version') { should match(/^21.3/) }
end

describe package('rabbitmq-server') do
  it { should be_installed }
end

describe service('rabbitmq-server') do
  it { should be_running }
end

describe command('erl') do
  it { should exist }
end

describe command('epmd') do
  it { should exist }
end

describe command('HOSTNAME=$(hostname) rabbitmq-diagnostics ping') do
  its(:exit_status) { should eq 0 }
end

describe command('HOSTNAME=$(hostname) rabbitmqctl ping') do
  its(:exit_status) { should eq 0 }
end

describe command('HOSTNAME=$(hostname) rabbitmq-plugins list') do
  its(:exit_status) { should eq 0 }
end
