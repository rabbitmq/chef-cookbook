# The Inspec reference, with examples and extensive documentation, can be
# found at https://inspec.io/docs/reference/resources/

%w(
  erlang-asn1 erlang-crypto erlang-public-key erlang-ssl erlang-syntax-tools
  erlang-mnesia erlang-runtime-tools erlang-snmp erlang-os-mon erlang-parsetools
  erlang-inets erlang-tools erlang-eldap erlang-xmerl
  erlang-dev erlang-edoc erlang-eunit erlang-erl-docgen erlang-src
).each do |p|
  describe package(p) do
    it { should be_installed }
    its('version') { should match(/^1:21.3/) }
  end
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
