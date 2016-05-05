# Encoding: utf-8
require 'chefspec'
require 'chefspec/berkshelf'
require 'fauxhai'
ChefSpec::Coverage.start!

require 'chef/application'

LOG_LEVEL = :fatal
SUSE_OPTS = {
  :platform => 'suse',
  :version => '11.3',
  :log_level => LOG_LEVEL
}.freeze
REDHAT_OPTS = {
  :platform => 'redhat',
  :version => '6.5',
  :log_level => LOG_LEVEL,
  :file_cache_path => '/tmp'
}.freeze
UBUNTU_OPTS = {
  :platform => 'ubuntu',
  :version => '14.04',
  :log_level => LOG_LEVEL,
  :file_cache_path => '/tmp'
}.freeze
CENTOS_OPTS = {
  :platform => 'centos',
  :version => '7.0',
  :log_level => LOG_LEVEL,
  :file_cache_path => '/tmp'
}.freeze
FEDORA_OPTS = {
  :platform => 'fedora',
  :version => '20',
  :log_level => LOG_LEVEL,
  :file_cache_path => '/tmp'
}.freeze

shared_context 'rabbitmq-stubs' do
  before do
    allow_any_instance_of(Chef::Config).to receive(:file_cache_path)
      .and_return('/tmp')
  end
end
