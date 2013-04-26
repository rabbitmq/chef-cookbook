# Latest RabbitMQ.com version to install
default['rabbitmq']['version'] = '3.0.4'
# The distro versions may be more stable and have back-ported patches
default['rabbitmq']['use_distro_version'] = false

# being nil, the rabbitmq defaults will be used
default['rabbitmq']['nodename']  = nil
default['rabbitmq']['address']  = nil
default['rabbitmq']['port']  = nil
default['rabbitmq']['config'] = nil
default['rabbitmq']['logdir'] = nil
default['rabbitmq']['mnesiadir'] = "/var/lib/rabbitmq/mnesia"
default['rabbitmq']['service_name'] = 'rabbitmq-server'

# config file location
# http://www.rabbitmq.com/configure.html#define-environment-variables
# "The .config extension is automatically appended by the Erlang runtime."
default['rabbitmq']['config_root'] = "/etc/rabbitmq"
default['rabbitmq']['config'] = "/etc/rabbitmq/rabbitmq"
default['rabbitmq']['erlang_cookie_path'] = '/var/lib/rabbitmq/.erlang.cookie'

# rabbitmq.config defaults
default['rabbitmq']['default_user'] = 'guest'
default['rabbitmq']['default_pass'] = 'guest'

#clustering
default['rabbitmq']['cluster'] = false
default['rabbitmq']['cluster_disk_nodes'] = []
default['rabbitmq']['erlang_cookie'] = 'AnyAlphaNumericStringWillDo'

# resource usage
default['rabbitmq']['disk_free_limit_relative'] = nil
default['rabbitmq']['vm_memory_high_watermark'] = nil

#ssl
default['rabbitmq']['ssl'] = false
default['rabbitmq']['ssl_port'] = 5671
default['rabbitmq']['ssl_cacert'] = '/path/to/cacert.pem'
default['rabbitmq']['ssl_cert'] = '/path/to/cert.pem'
default['rabbitmq']['ssl_key'] = '/path/to/key.pem'
default['rabbitmq']['ssl_verify'] = 'verify_none'
default['rabbitmq']['ssl_fail_if_no_peer_cert'] = false

#virtualhosts
default['rabbitmq']['virtualhosts'] = []

#users
default['rabbitmq']['enabled_users'] =
  [{ :name => "guest", :password => "guest", :rights =>
    [{:vhost => nil , :conf => ".*", :write => ".*", :read => ".*"}]
  }]
default['rabbitmq']['disabled_users'] =[]

#plugins
default['rabbitmq']['enabled_plugins'] = []
default['rabbitmq']['disabled_plugins'] = []

#platform specific settings
case node['platform_family']
when 'debian'
  default['rabbitmq']['package'] = "https://www.rabbitmq.com/releases/rabbitmq-server/v#{node['rabbitmq']['version']}/rabbitmq-server_#{node['rabbitmq']['version']}-1_all.deb"
when 'rhel'
  default['rabbitmq']['package'] = "https://www.rabbitmq.com/releases/rabbitmq-server/v#{node['rabbitmq']['version']}/rabbitmq-server-#{node['rabbitmq']['version']}-1.noarch.rpm"

when 'smartos'
  default['rabbitmq']['service_name'] = 'rabbitmq'
  default['rabbitmq']['config_root'] = '/opt/local/etc/rabbitmq'
  default['rabbitmq']['config'] = '/opt/local/etc/rabbitmq/rabbitmq'
  default['rabbitmq']['erlang_cookie_path'] = '/var/db/rabbitmq/.erlang.cookie'
end

# Example HA policies
default['rabbitmq']['policies']['ha-all']['pattern'] = "^(?!amq\\.).*"
default['rabbitmq']['policies']['ha-all']['params'] = { "ha-mode" => "all" }
default['rabbitmq']['policies']['ha-all']['priority'] = 0

default['rabbitmq']['policies']['ha-two']['pattern'] = "^two\."
default['rabbitmq']['policies']['ha-two']['params'] = { "ha-mode" => "exactly", "ha-params" => 2 }
default['rabbitmq']['policies']['ha-two']['priority'] = 1

