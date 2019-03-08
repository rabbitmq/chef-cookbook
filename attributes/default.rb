# frozen_string_literal: true
# Version to install
default['rabbitmq']['version'] = '3.7.13'

default['rabbitmq']['package_source'] = "github"

# When true, distribution-provided package will be used.
# This may be useful e.g. on old distributions.
default['rabbitmq']['use_distro_version'] = false
# Allow the distro version to be optionally pinned
default['rabbitmq']['pin_distro_version'] = false

# provide options to override download urls and package names
default['rabbitmq']['deb_package'] = nil
default['rabbitmq']['deb_package_url'] = nil

default['rabbitmq']['rpm_package'] = nil
default['rabbitmq']['rpm_package_url'] = nil

default['rabbitmq']['socat_package'] = 'socat-1.7.2.3-1.el6.x86_64.rpm'
default['rabbitmq']['socat_package_url'] = 'https://kojipkgs.fedoraproject.org//packages/socat/1.7.2.3/1.el6/x86_64/'

# Set to true when using recipe[rabbitmq::erlang_package]
default['rabbitmq']['erlang']['enabled'] = false

# On older distributions use ESL packages unless node['rabbitmq']['erlang']['enabled']
# suggests that the intent is to use recipe[rabbitmq::erlang_package]
#
if !node['rabbitmq']['use_distro_version'] && !node['rabbitmq']['erlang']['enabled'] &&
   (node['platform'] == 'debian' && node['platform_version'].to_i < 8 ||
    node['platform_family'] == 'rhel' && node['platform_version'].to_i < 7)
  default['erlang']['install_method'] = 'esl'
end

default['rabbitmq']['esl-erlang_package'] = 'esl-erlang-compat-20.2.2-1.noarch.rpm'
default['rabbitmq']['esl-erlang_package_url'] = 'https://github.com/jasonmcintosh/esl-erlang-compat/raw/master/rpmbuild/RPMS/noarch/'

# being nil, the rabbitmq defaults will be used
default['rabbitmq']['nodename'] = nil
default['rabbitmq']['address'] = nil
default['rabbitmq']['port'] = nil
default['rabbitmq']['config'] = nil
default['rabbitmq']['logdir'] = nil
default['rabbitmq']['server_additional_erl_args'] = nil
default['rabbitmq']['ctl_erl_args'] = nil
default['rabbitmq']['mnesiadir'] = '/var/lib/rabbitmq/mnesia'
default['rabbitmq']['service_name'] = 'rabbitmq-server'

default['rabbitmq']['manage_service'] = true
# service management operation retries. These defaults
# as the same as Chef's.
default['rabbitmq']['retry'] = 0
default['rabbitmq']['retry_delay'] = 2

# config file location
# http://www.rabbitmq.com/configure.html#define-environment-variables
# "The .config extension is automatically appended unless a file extension is already present."
default['rabbitmq']['config_root'] = '/etc/rabbitmq'
default['rabbitmq']['config'] = "#{node['rabbitmq']['config_root']}/rabbitmq"
default['rabbitmq']['erlang_cookie_path'] = '/var/lib/rabbitmq/.erlang.cookie'
default['rabbitmq']['erlang_cookie'] = 'AnyAlphaNumericStringWillDo'
# override this if you wish to provide `rabbitmq.config.erb` in your own wrapper cookbook
default['rabbitmq']['config_template_cookbook'] = 'rabbitmq'
# override this if you wish to provide `rabbitmq-env.config.erb` in your own wrapper cookbook
default['rabbitmq']['config-env_template_cookbook'] = 'rabbitmq'

# rabbitmq.config defaults
default['rabbitmq']['default_user'] = 'guest'
default['rabbitmq']['default_pass'] = 'guest'

## loopback_users
## List of users which are only permitted to connect to the broker via a loopback interface (i.e. localhost).
## If you wish to allow the default guest user to connect remotely, you need to change this to [].
default['rabbitmq']['loopback_users'] = nil

## Erlang kernel application options
## See http://www.erlang.org/doc/man/kernel_app.html
default['rabbitmq']['kernel']['inet_dist_listen_min'] = nil
default['rabbitmq']['kernel']['inet_dist_listen_max'] = nil

# Tell Erlang what IP to bind to
default['rabbitmq']['kernel']['inet_dist_use_interface'] = nil

## clustering
default['rabbitmq']['clustering']['enable'] = false
default['rabbitmq']['clustering']['cluster_partition_handling'] = 'ignore'

default['rabbitmq']['clustering']['use_auto_clustering'] = false
default['rabbitmq']['clustering']['cluster_name'] = nil

### an array of hashes with two keys: name and property
default['rabbitmq']['clustering']['cluster_nodes'] = []

## Chef-driven clustering.
##
## Note that there are no leader/master or follower nodes in RabbitMQ,
## all nodes are equal peers: http://www.rabbitmq.com/clustering.html#peer-equality
default['rabbitmq']['clustering']['node_type']         = 'master'
default['rabbitmq']['clustering']['master_node_name']  = 'rabbit@rabbit1'
default['rabbitmq']['clustering']['cluster_node_type'] = 'disc'

## log levels
default['rabbitmq']['log_levels'] = { 'connection' => 'info' }

## Logrotate
default['rabbitmq']['logrotate']['enable'] = true
default['rabbitmq']['logrotate']['path'] = '/var/log/rabbitmq/*.log'
default['rabbitmq']['logrotate']['rotate'] = 20
default['rabbitmq']['logrotate']['frequency'] = 'weekly'
default['rabbitmq']['logrotate']['options'] = %w(missingok notifempty delaycompress)
default['rabbitmq']['logrotate']['sharedscripts'] = true
default['rabbitmq']['logrotate']['postrotate'] = '/usr/sbin/rabbitmqctl rotate_logs > /dev/null'

## OS/kernel resource usage
default['rabbitmq']['disk_free_limit_relative'] = nil
default['rabbitmq']['disk_free_limit'] = nil
default['rabbitmq']['vm_memory_high_watermark'] = nil
default['rabbitmq']['max_file_descriptors'] = 1024
default['rabbitmq']['open_file_limit'] = nil

## job control
default['rabbitmq']['job_control'] = 'initd'

## TLS
default['rabbitmq']['ssl'] = false
default['rabbitmq']['ssl_port'] = 5671
default['rabbitmq']['ssl_listen_interface'] = nil
default['rabbitmq']['ssl_cacert'] = '/path/to/cacert.pem'
default['rabbitmq']['ssl_cert'] = '/path/to/cert.pem'
default['rabbitmq']['ssl_key'] = '/path/to/key.pem'
default['rabbitmq']['ssl_verify'] = 'verify_none'
default['rabbitmq']['ssl_fail_if_no_peer_cert'] = false
# Specify TLS versions
# Example:
#   ['tlsv1.2', 'tlsv1.1']
default['rabbitmq']['ssl_versions'] = nil
# Specify TLS ciphers
# Examples:
# ['{ecdhe_ecdsa,aes_128_cbc,sha256}', '{ecdhe_ecdsa,aes_256_cbc,sha}']
# or in OpenSSL format:
# ['"ECDHE-ECDSA-AES128-SHA256"', '"ECDHE-ECDSA-AES256-SHA"']
default['rabbitmq']['ssl_ciphers'] = nil
default['rabbitmq']['ssl_secure_renegotiate'] = true
default['rabbitmq']['ssl_honor_cipher_order'] = true
default['rabbitmq']['ssl_honor_ecc_order'] = true

default['rabbitmq']['web_console_ssl'] = false
default['rabbitmq']['web_console_ssl_port'] = 15_671

# If configured to true, allows downstream cookbooks to supply definitions on start
default['rabbitmq']['management']['load_definitions'] = false
default['rabbitmq']['management']['definitions_file'] = '/etc/rabbitmq/load_definitions.json'

# Change non SSL web console listen port
default['rabbitmq']['web_console_port'] = 15672

# Add an ability to set web console listen ip.
default['rabbitmq']['web_console_interface'] = nil

# TCP listener options, see
# https://www.rabbitmq.com/networking.html for details.
default['rabbitmq']['tcp_listen'] = true

default['rabbitmq']['port'] = 5672
default['rabbitmq']['tcp_listen_interface'] = nil

default['rabbitmq']['tcp_listen_packet'] = 'raw'
default['rabbitmq']['tcp_listen_reuseaddr'] = true
default['rabbitmq']['tcp_listen_backlog'] = 128
default['rabbitmq']['tcp_listen_nodelay'] = true
default['rabbitmq']['tcp_listen_exit_on_close'] = false
default['rabbitmq']['tcp_listen_keepalive'] = false
default['rabbitmq']['tcp_listen_linger'] = true
default['rabbitmq']['tcp_listen_linger_timeout'] = 0
default['rabbitmq']['tcp_listen_buffer'] = nil
default['rabbitmq']['tcp_listen_sndbuf'] = nil
default['rabbitmq']['tcp_listen_recbuf'] = nil

# virtualhosts
default['rabbitmq']['virtualhosts'] = []
default['rabbitmq']['disabled_virtualhosts'] = []

# users
default['rabbitmq']['enabled_users'] =
  [{ name: 'guest', password: 'guest', rights:
    [{ vhost: nil, conf: '.*', write: '.*', read: '.*' }]
  }]
default['rabbitmq']['disabled_users'] = []

# plugins
default['rabbitmq']['enabled_plugins'] = []
default['rabbitmq']['disabled_plugins'] = []
default['rabbitmq']['community_plugins'] = {}

# systemd unit files directory
default['rabbitmq']['systemd_unit_root'] = '/etc/systemd/system/rabbitmq-server.service.d'

default['rabbitmq']['systemd']['limits']['NOFILE'] = 500_000

# platform specific settings
case node['platform_family']
when 'smartos'
  default['rabbitmq']['service_name'] = 'rabbitmq'
  default['rabbitmq']['config_root'] = '/opt/local/etc/rabbitmq'
  default['rabbitmq']['config'] = "#{node['rabbitmq']['config_root']}/rabbitmq"
  default['rabbitmq']['erlang_cookie_path'] = '/var/db/rabbitmq/.erlang.cookie'
when 'debian'
  default['apt']['confd']['assume_yes'] = false
  default['apt']['confd']['force-yes'] = false
end

# heartbeat
default['rabbitmq']['heartbeat'] = 60

# per default all policies and disabled policies are empty but need to be
# defined
default['rabbitmq']['policies'] = {}
default['rabbitmq']['disabled_policies'] = []

# Example HA policies
# default['rabbitmq']['policies']['ha-all']['pattern'] = '^(?!amq\\.).*'
# default['rabbitmq']['policies']['ha-all']['params'] = { 'ha-mode' => 'all' }
# default['rabbitmq']['policies']['ha-all']['priority'] = 0
#
# default['rabbitmq']['policies']['ha-two']['pattern'] = '^two.'
# default['rabbitmq']['policies']['ha-two']['params'] = { 'ha-mode' => 'exactly', 'ha-params' => 2 }
# default['rabbitmq']['policies']['ha-two']['priority'] = 1

# conf
default['rabbitmq']['conf'] = {}
default['rabbitmq']['additional_rabbit_configs'] = {}

#
# Erlang packages
#

# if setting to a specific version, apt repository components
# will have to be updated
default['rabbitmq']['erlang']['version'] = nil
default['rabbitmq']['erlang']['hipe'] = false
default['rabbitmq']['erlang']['retry_delay'] = 10

# apt
default['rabbitmq']['erlang']['apt']['uri'] = "https://dl.bintray.com/rabbitmq-erlang/debian"
default['rabbitmq']['erlang']['apt']['lsb_codename'] = node['lsb']['codename'] rescue nil
default['rabbitmq']['erlang']['apt']['components'] = ["erlang"]
default['rabbitmq']['erlang']['apt']['key'] = "6B73A36E6026DFCA"

default['rabbitmq']['erlang']['apt']['install_options'] = %w(--fix-missing)

# yum
default['rabbitmq']['erlang']['yum']['baseurl'] = case node['platform_family']
                                                  when 'rhel'
                                                    "https://dl.bintray.com/rabbitmq-erlang/rpm/erlang/21/el/#{node['platform_version'].to_i}"
                                                  else
                                                    # Fedora and so on
                                                    'https://dl.bintray.com/rabbitmq-erlang/rpm/erlang/21/el/7'
                                                  end
default['rabbitmq']['erlang']['yum']['gpgkey'] = 'https://dl.bintray.com/rabbitmq/Keys/rabbitmq-release-signing-key.asc'
default['rabbitmq']['erlang']['yum']['gpgcheck'] = true
default['rabbitmq']['erlang']['yum']['repo_gpgcheck'] = false
default['rabbitmq']['erlang']['yum']['enabled'] = true
