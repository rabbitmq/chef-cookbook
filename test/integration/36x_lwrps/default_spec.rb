# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe package('rabbitmq-server') do
  it { should be_installed }
end

describe service('rabbitmq-server') do
  it { should be_running }
end

describe command('HOSTNAME=$(hostname) rabbitmq-plugins list') do
  its(:exit_status) { should eq 0 }
end

describe command('curl -u guest:guest -H "Accept: application/json" -X GET "http://localhost:15672/api/overview"') do
  its(:exit_status) { should eq 0 }
end

describe command('rabbitmqctl -q list_policies') do
  its(:stdout) { should match(%r{{"ha-mode":"all","ha-sync-mode":"automatic"}}) }
end

describe command('rabbitmqctl -q list_parameters -p sensu') do
  its(:stdout) { should match(%r{federation-upstream\s+sensu-dc-1\s+{"uri":"amqp:\/\/dc-cluster-node"}}) }
end
