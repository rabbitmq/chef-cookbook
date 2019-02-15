# frozen_string_literal: true
require 'spec_helper'

describe 'rabbitmq::default' do
  let(:runner) { ChefSpec::ServerRunner.new(REDHAT_OPTS) }
  let(:node) { runner.node }

  let(:chef_run) do
    runner.converge(described_recipe)
  end

  let(:file_cache_path) { Chef::Config[:file_cache_path] }

  include_context 'rabbitmq-stubs'

  it 'creates a directory for mnesiadir' do
    expect(chef_run).to create_directory('/var/lib/rabbitmq/mnesia')
  end

  describe 'rabbitmq-env.conf' do
    let(:file) { chef_run.template('/etc/rabbitmq/rabbitmq-env.conf') }

    it 'creates a template rabbitmq-env.conf with attributes' do
      expect(chef_run).to create_template(file.name).with(
        :user => 'root',
        :group => 'root',
        :source => 'rabbitmq-env.conf.erb',
        :mode => 00644)
    end

    it 'has no erl args by default' do
      [/^SERVER_ADDITIONAL_ERL_ARGS=/,
       /^CTL_ERL_ARGS=/].each do |line|
        expect(chef_run).not_to render_file(file.name).with_content(line)
      end
    end

    it 'has erl args overridden' do
      node.normal['rabbitmq']['server_additional_erl_args'] = 'test123'
      node.normal['rabbitmq']['ctl_erl_args'] = 'test123'
      [/^SERVER_ADDITIONAL_ERL_ARGS='test123'/,
       /^CTL_ERL_ARGS='test123'/].each do |line|
        expect(chef_run).to render_file(file.name).with_content(line)
      end
    end

    it 'has no additional_env_settings default' do
      expect(chef_run).not_to render_file(file.name).with_content(/^# Additional ENV settings/)
    end

    it 'has additional_env_settings' do
      node.normal['rabbitmq']['additional_env_settings'] = [
        'USE_LONGNAME=true',
        'WHATS_ON_THE_TELLY=penguin']
      [/^WHATS_ON_THE_TELLY=penguin/,
       /^# Additional ENV settings/,
       /^USE_LONGNAME=true/].each do |line|
        expect(chef_run).to render_file(file.name).with_content(line)
      end
    end
  end

  it 'should create the config root directory' do
    expect(chef_run).to create_directory('/etc/rabbitmq')
      .with(
        :user => 'root',
        :group => 'root',
        :mode => '755'
      )
  end

  it 'should create the node data directory' do
    expect(chef_run).to create_directory('/var/lib/rabbitmq/mnesia')
      .with(
        :user => 'rabbitmq',
        :group => 'rabbitmq',
        :mode => '775'
      )
  end

  it 'does not enable a rabbitmq service when manage_service is false' do
    node.normal['rabbitmq']['manage_service'] = false
    expect(chef_run).not_to enable_service('rabbitmq-server')
  end

  it 'does not start a rabbitmq service when manage_service is false' do
    node.normal['rabbitmq']['manage_service'] = false
    expect(chef_run).not_to start_service('rabbitmq-server')
  end

  it 'enables a rabbitmq service when manage_service is true' do
    node.normal['rabbitmq']['manage_service'] = true
    expect(chef_run).to enable_service('rabbitmq-server')
  end

  it 'starts a rabbitmq service when manage_service is true' do
    node.normal['rabbitmq']['manage_service'] = true
    expect(chef_run).to start_service('rabbitmq-server')
  end

  it 'should have the use_distro_version set to false' do
    expect(chef_run.node['rabbitmq']['use_distro_version']).to eq(false)
  end

  it 'should install the erlang package' do
    expect(chef_run).to install_package('erlang')
  end

  it 'should create the rabbitmq /etc/default file' do
    expect(chef_run).to create_template("/etc/default/#{chef_run.node['rabbitmq']['service_name']}").with(
      :user => 'root',
      :group => 'root',
      :source => 'default.rabbitmq-server.erb',
      :mode => 00644
    )
  end

  it 'creates a template rabbitmq.config with attributes' do
    expect(chef_run).to create_template('/etc/rabbitmq/rabbitmq.config').with(
      :user => 'root',
      :group => 'root',
      :source => 'rabbitmq.config.erb',
      :mode => 00644)

    if Gem::Version.new(Chef::VERSION.to_s) >= Gem::Version.new('11.14.2')
      expect(chef_run).to create_template('/etc/rabbitmq/rabbitmq.config').with(:sensitive => true)
    else
      expect(chef_run).to create_template('/etc/rabbitmq/rabbitmq.config').with(:sensitive => false)
    end
  end

  it 'should set additional rabbitmq config' do
    node.normal['rabbitmq']['additional_rabbit_configs'] = { 'foo' => 'bar' }
    expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content('foo, bar')
  end

  describe 'TLS configuration' do
    it 'has no ssl ciphers specified by default' do
      expect(chef_run).not_to render_file('/etc/rabbitmq/rabbitmq.config').with_content(
        /{ciphers,[{.*}]}/)
    end

    it 'enables secure renegotiation by default' do
      node.normal['rabbitmq']['ssl'] = true
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content(
        '{secure_renegotiate, true}')
    end

    it 'uses server cipher suite preference by default' do
      node.normal['rabbitmq']['ssl'] = true
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content(
        '{honor_cipher_order, true}')
    end

    it 'uses server ECC curve preference by default' do
      node.normal['rabbitmq']['ssl'] = true
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content(
        '{honor_ecc_order, true}')
    end

    it 'allows ssl ciphers' do
      node.normal['rabbitmq']['ssl'] = true
      node.normal['rabbitmq']['ssl_ciphers'] = ['{ecdhe_ecdsa,aes_128_cbc,sha256}', '{ecdhe_ecdsa,aes_256_cbc,sha}']
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content(
        '{ciphers,[{ecdhe_ecdsa,aes_128_cbc,sha256},{ecdhe_ecdsa,aes_256_cbc,sha}]}')
    end

    it 'allows web console ssl ciphers' do
      node.normal['rabbitmq']['web_console_ssl'] = true
      node.normal['rabbitmq']['ssl_ciphers'] = ['"ECDHE-ECDSA-AES256-SHA384"', '"ECDH-ECDSA-AES256-SHA384"']
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content(
        '{ciphers,["ECDHE-ECDSA-AES256-SHA384","ECDH-ECDSA-AES256-SHA384"]}')
    end

    it 'does not set interface to listen for SSL by default' do
      node.normal['rabbitmq']['ssl'] = true
      expect(chef_run).not_to render_file('/etc/rabbitmq/rabbitmq.config').with_content(
        /{ssl_listeners, [5671]},/)
    end

    it 'is setting interface to listen for SSL if set' do
      node.normal['rabbitmq']['ssl'] = true
      node.normal['rabbitmq']['ssl_listen_interface'] = '0.0.0.0'
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content(
        /{ssl_listeners, \[{"0.0.0.0", 5671}\]},/)
    end

    it 'is setting port to listen for SSL if set' do
      node.normal['rabbitmq']['ssl'] = true
      node.normal['rabbitmq']['ssl_port'] = 5670
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content(
        /{ssl_listeners, \[5670\]},/)
    end
  end

  describe 'TCP listener options' do
    it 'allows interface to be overridden' do
      node.normal['rabbitmq']['tcp_listen_interface'] = '192.168.1.10'
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content('{"192.168.1.10", 5672}')
    end

    it 'allows AMQP port to be overridden' do
      node.normal['rabbitmq']['port'] = 5674
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content('[5674]')
    end

    it 'enables socket lingering by default' do
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content('{linger, {true,0}}')
    end

    it 'supports disabling lingering' do
      node.normal['rabbitmq']['tcp_listen_linger'] = false
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content('{linger, {false,0}}')
    end

    it 'supports setting lingering timeout' do
      node.normal['rabbitmq']['tcp_listen_linger_timeout'] = 5
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content('{linger, {true,5}}')
    end

    it 'supports explicit setting of TCP socket buffer' do
      node.normal['rabbitmq']['tcp_listen_buffer'] = 16384
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content('{buffer, 16384}')
    end

    it 'supports explicit setting of TCP socket send buffer' do
      node.normal['rabbitmq']['tcp_listen_sndbuf'] = 8192
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content('{sndbuf, 8192}')
    end

    it 'supports explicit setting of TCP socket receive buffer' do
      node.normal['rabbitmq']['tcp_listen_recbuf'] = 8192
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content('{recbuf, 8192}')
    end
  end

  describe 'credit flow' do
    it 'can configure defaults' do
      node.normal['rabbitmq']['credit_flow_defaults']['initial'] = 500
      node.normal['rabbitmq']['credit_flow_defaults']['more_credit_after'] = 250
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content('{credit_flow_default_credit, {500, 250}}')
    end
  end

  describe 'suse' do
    let(:runner) { ChefSpec::ServerRunner.new(SUSE_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) do
      runner.converge(described_recipe)
    end

    it 'should install the socat package' do
      expect(chef_run).to install_package('socat')
    end

    it 'should install the logrotate package' do
      expect(chef_run).to install_package('logrotate')
    end

    it 'should install the rabbitmq package' do
      expect(chef_run).to install_package('rabbitmq-server')
    end

    it 'should install the rabbitmq plugin package' do
      expect(chef_run).to install_package('rabbitmq-server-plugins')
    end
  end

  describe 'ubuntu' do
    let(:runner) { ChefSpec::ServerRunner.new(UBUNTU_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) do
      node.normal['rabbitmq']['version'] = '3.6.16'
      runner.converge(described_recipe)
    end

    it 'creates a template for 90forceyes' do
      expect(chef_run).to create_template('/etc/apt/apt.conf.d/90forceyes')
    end

    include_context 'rabbitmq-stubs'

    # ~FC005 -- we should ignore this during compile time
    it 'should install the logrotate package' do
      expect(chef_run).to install_package('logrotate')
    end

    it 'should install the socat package' do
      expect(chef_run).to install_package('socat')
    end

    it 'creates a rabbitmq-server deb in the cache path' do
      expect(chef_run).to create_remote_file_if_missing('/tmp/rabbitmq-server_3.6.16-1_all.deb')
    end

    it 'installs the rabbitmq-server deb_package with the default action' do
      expect(chef_run).to upgrade_dpkg_package('rabbitmq-server')
    end

    it 'creates a template rabbitmq-server with attributes' do
      expect(chef_run).to create_template('/etc/default/rabbitmq-server').with(
        :user => 'root',
        :group => 'root',
        :source => 'default.rabbitmq-server.erb',
        :mode => 00644)
    end

    describe 'uses distro version' do
      before do
        node.normal['rabbitmq']['use_distro_version'] = true
      end

      it 'should install rabbitmq-server package' do
        expect(chef_run).to install_package('rabbitmq-server')
      end

      it 'should install the logrotate package' do
        expect(chef_run).to install_package('logrotate')
      end
    end
  end

  describe 'redhat' do
    let(:runner) { ChefSpec::ServerRunner.new(REDHAT_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) do
      runner.converge(described_recipe)
    end

    describe 'if redhat version is below 7' do
      let(:rpm_file) { 'rabbitmq-server-3.6.16-1.el6.noarch.rpm' }
      let(:runner) { ChefSpec::ServerRunner.new(REDHAT_OPTS.merge(:version => 6.9)) }

      it 'creates a rabbitmq-server rpm in the cache path' do
        expect(chef_run).to create_remote_file_if_missing("/tmp/#{rpm_file}")
      end

      it 'installs the rabbitmq-server rpm_package with the default action' do
        expect(chef_run).to install_rpm_package("/tmp/#{rpm_file}")
      end
    end

    describe 'if redhat version is default' do
      let(:rpm_file) { 'rabbitmq-server-3.6.16-1.el7.noarch.rpm' }

      it 'creates a rabbitmq-server rpm in the cache path' do
        expect(chef_run).to create_remote_file_if_missing("/tmp/#{rpm_file}")
      end

      it 'installs the rabbitmq-server rpm_package with the default action' do
        expect(chef_run).to install_rpm_package("/tmp/#{rpm_file}")
      end
    end

    describe 'uses distro version' do
      before do
        node.normal['rabbitmq']['use_distro_version'] = true
      end

      it 'should install rabbitmq-server package' do
        expect(chef_run).to install_package('rabbitmq-server')
      end
    end

    it 'loopback_users will not show in config file unless attribute is specified' do
      expect(chef_run).not_to render_file('/etc/rabbitmq/rabbitmq.config').with_content('loopback_users')
    end

    it 'loopback_users is empty when attribute is empty array' do
      node.normal['rabbitmq']['loopback_users'] = []
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content('loopback_users, []')
    end

    it 'loopback_users can list single user' do
      node.normal['rabbitmq']['loopback_users'] = ['foo']
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content('loopback_users, [<<"foo">>]')
    end

    it 'loopback_users can list multiple users' do
      node.normal['rabbitmq']['loopback_users'] = %w(foo bar)
      expect(chef_run).to render_file('/etc/rabbitmq/rabbitmq.config').with_content('loopback_users, [<<"foo">>,<<"bar">>]')
    end

    it 'should install the logrotate package' do
      expect(chef_run).to install_package('logrotate')
    end

    it 'should install the socat package' do
      expect(chef_run).to install_package('socat')
    end
  end

  describe 'centos' do
    let(:runner) { ChefSpec::ServerRunner.new(CENTOS_OPTS) }
    let(:node) { runner.node }
    let(:chef_run) do
      runner.converge(described_recipe)
    end

    it 'should install the logrotate package' do
      expect(chef_run).to install_package('logrotate')
    end

    it 'should install the socat package' do
      expect(chef_run).to install_package('socat')
    end

    describe 'if centos version is below 7' do
      let(:rpm_file) { 'rabbitmq-server-3.6.16-1.el6.noarch.rpm' }
      let(:runner) { ChefSpec::ServerRunner.new(CENTOS_OPTS.merge(:version => 6.9)) }

      it 'creates a rabbitmq-server rpm in the cache path' do
        expect(chef_run).to create_remote_file_if_missing("/tmp/#{rpm_file}")
      end

      it 'installs the rabbitmq-server rpm_package with the default action' do
        expect(chef_run).to install_rpm_package("/tmp/#{rpm_file}")
      end
    end

    describe 'if centos version is default' do
      let(:rpm_file) { 'rabbitmq-server-3.6.16-1.el7.noarch.rpm' }

      it 'creates a rabbitmq-server rpm in the cache path' do
        expect(chef_run).to create_remote_file_if_missing("/tmp/#{rpm_file}")
      end

      it 'installs the rabbitmq-server rpm_package with the default action' do
        expect(chef_run).to install_rpm_package("/tmp/#{rpm_file}")
      end
    end

    it 'includes the `yum-epel` recipe' do
      expect(chef_run).to include_recipe('yum-epel')
    end

    describe 'uses distro version' do
      before do
        node.normal['rabbitmq']['use_distro_version'] = true
      end

      it 'should install rabbitmq-server package' do
        expect(chef_run).to install_package('rabbitmq-server')
      end
    end
  end
end
