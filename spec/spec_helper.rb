# Encoding: utf-8
# frozen_string_literal: true
require 'chefspec'
require 'chefspec/berkshelf'
require 'fauxhai'

require 'chef/application'

# rubocop:disable all

SPEC_LOG_LEVEL = :fatal
SUSE_OPTS = {
  :platform => 'suse',
  :version => '12.5',
  :log_level => SPEC_LOG_LEVEL
}
REDHAT_OPTS = {
  :platform => 'redhat',
  :version => '8',
  :log_level => SPEC_LOG_LEVEL,
  :file_cache_path => '/tmp'
}
UBUNTU_OPTS = {
  :platform => 'ubuntu',
  :version => '18.04',
  :log_level => SPEC_LOG_LEVEL,
  :file_cache_path => '/tmp'
}
CENTOS7_OPTS = {
  :platform => 'centos',
  :version => '7.7.1908',
  :log_level => SPEC_LOG_LEVEL,
  :file_cache_path => '/tmp'
}
CENTOS_OPTS = CENTOS7_OPTS
CENTOS6_OPTS = {
  :platform => 'centos',
  :version => '6.10',
  :log_level => SPEC_LOG_LEVEL,
  :file_cache_path => '/tmp'
}
FEDORA_OPTS = {
  platform: 'fedora',
  version: '32',
  log_level: SPEC_LOG_LEVEL,
  file_cache_path: '/tmp'
}

CLUSTER_OPTS = {
  platform: 'centos',
  version: '7.7.1908',
  log_level: SPEC_LOG_LEVEL,
  file_cache_path: '/tmp',

  'rabbitmq' => {
    'clustering' => {
      'use_auto_clustering' => false,
      'cluster_nodes'       => [
        {name: "rabbit@node1", type: "disc"},
        {name: "rabbit@node2", type: "disc"}
      ]
    }
  }
}

# rubocop:enable all

shared_context 'rabbitmq-stubs' do
  before do
    allow_any_instance_of(Chef::Config).to receive(:file_cache_path)
      .and_return('/tmp')
  end
end
