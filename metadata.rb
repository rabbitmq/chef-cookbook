# frozen_string_literal: true
name 'rabbitmq'
maintainer 'Chef, Inc. and contributors'
maintainer_email 'mklishin@pivotal.io'
license 'Apache-2.0'
description 'Installs and configures RabbitMQ server'
version '5.8.5'

recipe 'rabbitmq', 'Install and configure RabbitMQ'

recipe 'rabbitmq::systemd_limits', 'Sets up kernel limits (e.g. nofile) for RabbitMQ via systemd'
recipe 'rabbitmq::cluster', 'Set up RabbitMQ clustering.'

recipe 'rabbitmq::management_ui', 'Sets up RabbitMQ management plugin/UI'
recipe 'rabbitmq::mgmt_console', 'Deprecated, alias for rabbitmq::management_ui'

recipe 'rabbitmq::plugins', 'Manage plugins with node attributes'
recipe 'rabbitmq::plugin_management', 'Deprecated, alias for rabbitmq::plugins'

recipe 'rabbitmq::vhosts', 'Manage virtual hosts with node attributes'
recipe 'rabbitmq::virtualhost_management', 'Deprecated, alias for rabbitmq::vhosts'

recipe 'rabbitmq::users', 'Manage users with node attributes'
recipe 'rabbitmq::user_management', 'Deprecated, alias for rabbitmq::users'

recipe 'rabbitmq::policies', 'Manage policies with node attributes'
recipe 'rabbitmq::policy_management', 'Deprecated, alias for rabbitmq::policies'

recipe 'rabbitmq::erlang_package', 'Provisions Erlang via Team RabbitMQ packages'
recipe 'rabbitmq::esl_erlang_package', 'Alias for erlang::esl'

issues_url 'https://github.com/rabbitmq/chef-cookbook/issues'
source_url 'https://github.com/rabbitmq/chef-cookbook'

chef_version '>= 13.0'

depends 'erlang'
depends 'yum-epel'
depends 'yum-erlang_solutions'
depends 'dpkg_autostart'
depends 'logrotate'

supports 'amazon', '>= 2.0'
supports 'centos', '>= 7.0'
supports 'debian', '>= 8.0'
supports 'opensuse'
supports 'opensuseleap'
supports 'oracle'
supports 'redhat'
supports 'scientific'
supports 'smartos'
supports 'suse'
supports 'ubuntu', '>= 14.04'
