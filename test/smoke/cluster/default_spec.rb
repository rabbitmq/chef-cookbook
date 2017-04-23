# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe file('/var/lib/rabbitmq/.erlang.cookie') do
  it { should be_file }
end

describe file('/etc/rabbitmq/rabbitmq.config') do
  it { should be_file }
  skip(:content) { should match(/^    {cluster_nodes, {.*}},$/) }
end
