# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe command('rabbitmqadmin --version') do
  its(:exit_status) { should eq 0 }
end

describe command('rabbitmqctl list_policies') do
  its(:stdout) { should match(%r{\/\s+rabbitmq_cluster\s+queues\s+cluster\.\*\s+{"ha-mode":"all","ha-sync-mode":"automatic"}\s+0}) }
end

describe command('rabbitmqctl list_parameters -p /sensu') do
  its(:stdout) { should match(%r{federation-upstream\s+sensu-dc-1\s+{"uri":"amqp:\/\/dc-cluster-node"}}) }
end
