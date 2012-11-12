# being nil, the rabbitmq defaults will be used
default['rabbitmq']['nodename']  = nil
default['rabbitmq']['address']  = nil
default['rabbitmq']['port']  = nil
default['rabbitmq']['config'] = nil
default['rabbitmq']['logdir'] = nil
default['rabbitmq']['mnesiadir'] = nil

default['rabbitmq']['service_name'] = 'rabbitmq-server'
if platform?('smartos')
  default['rabbitmq']['service_name'] = 'rabbitmq'
end

# RabbitMQ version to install for "redhat", "centos", "scientific", and "amazon".
default['rabbitmq']['version'] = '2.8.4'
# Override this if you have a yum repo with rabbitmq available.
default['rabbitmq']['use_yum'] = false
# Override this if you do not want to use an apt repo
default['rabbitmq']['use_apt'] = true
# The distro versions may be more stable and have back-ported patches
default['rabbitmq']['use_distro_version'] = false

# config file location
# http://www.rabbitmq.com/configure.html#define-environment-variables
# "The .config extension is automatically appended by the Erlang runtime."
default['rabbitmq']['config_root'] = "/etc/rabbitmq"
default['rabbitmq']['config'] = "/etc/rabbitmq/rabbitmq"
if platform?('smartos')
  default['rabbitmq']['config_root'] = "/opt/local/etc/rabbitmq"
  default['rabbitmq']['config'] = "/opt/local/etc/rabbitmq/rabbitmq"
end
default['rabbitmq']['erlang_cookie_path'] = '/var/lib/rabbitmq/.erlang.cookie'
if platform?('smartos')
  default['rabbitmq']['erlang_cookie_path'] = '/var/db/rabbitmq/.erlang.cookie'
end

# rabbitmq.config defaults
default['rabbitmq']['default_user'] = 'guest'
default['rabbitmq']['default_pass'] = 'guest'

#clustering
default['rabbitmq']['cluster'] = false
default['rabbitmq']['cluster_disk_nodes'] = []
default['rabbitmq']['erlang_cookie'] = 'AnyAlphaNumericStringWillDo'

#ssl
default['rabbitmq']['ssl'] = false
default['rabbitmq']['ssl_port'] = 5671
default['rabbitmq']['ssl_cacert'] = '/path/to/cacert.pem'
default['rabbitmq']['ssl_cert'] = '/path/to/cert.pem'
default['rabbitmq']['ssl_key'] = '/path/to/key.pem'
