# The Inspec reference, with examples and extensive documentation, can be
# found at https://inspec.io/docs/reference/resources/

describe command('curl -u guest:guest -H "Accept: application/json" -X GET "http://localhost:15672/api/overview"') do
  its(:exit_status) { should eq 0 }
end

describe command('rabbitmqctl list_policies -s') do
  its(:stdout) { should match(%r{{"ha-mode":"all","ha-sync-mode":"automatic"}}) }
end

describe command('rabbitmqctl list_parameters -s -p sensu') do
  its(:stdout) { should match(%r{federation-upstream\s+sensu-dc-1\s+{"uri":"amqp:\/\/dc-cluster-node"}}) }
end
