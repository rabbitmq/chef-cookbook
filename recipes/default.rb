# frozen_string_literal: true
#
# Cookbook Name:: rabbitmq
# Recipe:: default
#
# Copyright 2009, Benjamin Black
# Copyright 2009-2013, Chef Software, Inc.
# Copyright 2012, Kevin Nuckolls <kevin.nuckolls@gmail.com>
# Copyright 2016-2019, Pivotal Software, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

class Chef::Resource
  include RabbitMQ::CoreHelpers # rubocop:enable all
end

class Chef::Recipe
  include RabbitMQ::CoreHelpers # rubocop:enable all
end

unless node['rabbitmq']['erlang']['enabled']
  include_recipe 'erlang'
end

version = node['rabbitmq']['version']

default_package_url = if rabbitmq_37? || rabbitmq_38?
  # 3.7.0 and later
  "https://dl.bintray.com/rabbitmq/all/rabbitmq-server/#{version}/"
else
  # prior to 3.7.0
  legacy_version = version.tr('.', '_')
  "https://github.com/rabbitmq/rabbitmq-server/releases/download/rabbitmq_v#{legacy_version}/"
end

default_deb_package_name = "rabbitmq-server_#{version}-1_all.deb"

default_rpm_package_name = value_for_platform(
  %w(centos redhat scientific) => {
    '< 7.0' => "rabbitmq-server-#{version}-1.el6.noarch.rpm",
    'default' => "rabbitmq-server-#{version}-1.el7.noarch.rpm"
  },
  'fedora' => {
    'default' => "rabbitmq-server-#{version}-1.el7.noarch.rpm"
  },
  'amazon' => {
    '< 2.0' => "rabbitmq-server-#{version}-1.el6.noarch.rpm",
    'default' => "rabbitmq-server-#{version}-1.el7.noarch.rpm"
  },
  'suse' => {
    'default' => "rabbitmq-server-#{version}-1.suse.noarch.rpm"
  }
)

deb_package_name = node['rabbitmq']['deb_package'] || default_deb_package_name
deb_package_url = node['rabbitmq']['deb_package_url'] || default_package_url
rpm_package_name = node['rabbitmq']['rpm_package'] || default_rpm_package_name
rpm_package_url = node['rabbitmq']['rpm_package_url'] || default_package_url

# see rabbitmq/chef-cookbook#351
directory node['rabbitmq']['config_root'] do
  owner 'root'
  group 'root'
  mode  '755'
  recursive true
  action :create
end

## Install the package
if platform_family?('debian')
  template '/etc/apt/apt.conf.d/90forceyes' do
    source '90forceyes.erb'
    owner 'root'
    group 'root'
    mode '0644'
  end

  # logrotate is a package dependency of rabbitmq-server
  package 'logrotate'

  # socat is a package dependency of rabbitmq-server
  package 'socat'

  # => Prevent Debian systems from automatically starting RabbitMQ after dpkg install
  dpkg_autostart node['rabbitmq']['service_name'] do
    allow false
  end

  if node['platform_version'].to_i == 7 && !use_distro_version?
    Chef::Log.warn 'Debian 7 is too old to use the recent .deb RabbitMQ packages. Falling back to distro package!'
    node.normal['rabbitmq']['use_distro_version'] = true
  end

  if use_distro_version?
    package 'rabbitmq-server' do
      action :install
      version node['rabbitmq']['version'] if node['rabbitmq']['pin_distro_version']
      notifies :reload, 'ohai[reload_packages]', :immediately
    end
  else
    # we need to download the package
    remote_file "#{Chef::Config[:file_cache_path]}/#{deb_package_name}" do
      source "#{deb_package_url}#{deb_package_name}"
      action :create_if_missing
    end
    dpkg_package 'rabbitmq-server' do
      source ::File.join(Chef::Config[:file_cache_path], deb_package_name)
      action :upgrade
      notifies :reload, 'ohai[reload_packages]', :immediately
    end
  end

  if service_control_upstart? && manage_rabbitmq_service?
    # We start with stock init.d, remove it if we're not using init.d, otherwise leave it alone
    service node['rabbitmq']['service_name'] do
      action [:stop]
      only_if { ::File.exist?('/etc/init.d/rabbitmq-server') }
    end

    execute 'remove rabbitmq init.d command' do
      command 'update-rc.d -f rabbitmq-server remove'
    end

    file '/etc/init.d/rabbitmq-server' do
      action :delete
    end

    include_recipe 'logrotate'

    logrotate_app 'rabbitmq-server' do
      path node['rabbitmq']['logrotate']['path']
      enable node['rabbitmq']['logrotate']['enable']
      rotate node['rabbitmq']['logrotate']['rotate']
      frequency node['rabbitmq']['logrotate']['frequency']
      options node['rabbitmq']['logrotate']['options']
      sharedscripts node['rabbitmq']['logrotate']['sharedscripts']
      postrotate node['rabbitmq']['logrotate']['postrotate']
    end

    template "/etc/init/#{node['rabbitmq']['service_name']}.conf" do
      source 'rabbitmq.upstart.conf.erb'
      owner 'root'
      group 'root'
      mode '644'
      variables(max_file_descriptors: node['rabbitmq']['max_file_descriptors'])
    end
  end
end

if platform_family?('fedora')
  package 'logrotate'
  package 'socat'

  # This is needed since Erlang Solutions' packages provide "esl-erlang"; this package just requires "esl-erlang" and provides "erlang".
  if node['erlang']['install_method'] == 'esl'
    Chef::Log.info('Downloading a shim package for esl-erlang')
    remote_file "#{Chef::Config[:file_cache_path]}/esl-erlang-compat.rpm" do
      source "#{node['rabbitmq']['esl-erlang_package_url']}#{node['rabbitmq']['esl-erlang_package']}"
    end
    rpm_package "#{Chef::Config[:file_cache_path]}/esl-erlang-compat.rpm"
  end

  if use_distro_version?
    package 'rabbitmq-server' do
      action :install
      version node['rabbitmq']['version'] if node['rabbitmq']['pin_distro_version']
      notifies :reload, 'ohai[reload_packages]', :immediately
    end
  else
    remote_file "#{Chef::Config[:file_cache_path]}/#{rpm_package_name}" do
      source "#{rpm_package_url}#{rpm_package_name}"
      action :create_if_missing
    end
    rpm_package "#{Chef::Config[:file_cache_path]}/#{rpm_package_name}" do
      notifies :reload, 'ohai[reload_packages]', :immediately
    end
  end
end

if platform_family?('rhel')
  package 'logrotate'
  if node['platform_version'].to_i >= 7
    package 'socat'
  else
    Chef::Log.info('Downloading socat installation on CentOS 6')
    remote_file "#{Chef::Config[:file_cache_path]}/#{node['rabbitmq']['socat_package']}" do
      source "#{node['rabbitmq']['socat_package_url']}#{node['rabbitmq']['socat_package']}"
      action :create_if_missing
    end
    yum_package "#{Chef::Config[:file_cache_path]}/#{node['rabbitmq']['socat_package']}"
  end

  # This is needed since Erlang Solutions' packages provide "esl-erlang"; this package
  # just requires "esl-erlang" and provides "erlang".
  if node['erlang']['install_method'] == 'esl'
    Chef::Log.info('Downloading a shim package for esl-erlang')
    remote_file "#{Chef::Config[:file_cache_path]}/esl-erlang-compat.rpm" do
      source "#{node['rabbitmq']['esl-erlang_package_url']}#{node['rabbitmq']['esl-erlang_package']}"
    end
    rpm_package "#{Chef::Config[:file_cache_path]}/esl-erlang-compat.rpm"
  end

  if use_distro_version?
    package 'rabbitmq-server' do
      action :install
      version node['rabbitmq']['version'] if node['rabbitmq']['pin_distro_version']
      notifies :reload, 'ohai[reload_packages]', :immediately
    end
  else
    remote_file "#{Chef::Config[:file_cache_path]}/#{rpm_package_name}" do
      source "#{rpm_package_url}#{rpm_package_name}"
      action :create_if_missing
    end
    rpm_package "#{Chef::Config[:file_cache_path]}/#{rpm_package_name}" do
      notifies :reload, 'ohai[reload_packages]', :immediately
    end
  end
end

if platform_family?('amazon')
  package 'logrotate'
  package 'socat'

  # This is needed since Erlang Solutions' packages provide "esl-erlang"; this package
  # just requires "esl-erlang" and provides "erlang".
  if node['erlang']['install_method'] == 'esl'
    Chef::Log.info('Downloading a shim package for esl-erlang')
    remote_file "#{Chef::Config[:file_cache_path]}/esl-erlang-compat.rpm" do
      source "#{node['rabbitmq']['esl-erlang_package_url']}#{node['rabbitmq']['esl-erlang_package']}"
    end
    rpm_package "#{Chef::Config[:file_cache_path]}/esl-erlang-compat.rpm"
  end

  if use_distro_version?
    package 'rabbitmq-server' do
      action :install
      version node['rabbitmq']['version'] if node['rabbitmq']['pin_distro_version']

      notifies :reload, 'ohai[reload_packages]', :immediately
    end
  else
    remote_file "#{Chef::Config[:file_cache_path]}/#{rpm_package_name}" do
      source "#{rpm_package_url}#{rpm_package_name}"
      action :create_if_missing
    end
    yum_package "#{Chef::Config[:file_cache_path]}/#{rpm_package_name}" do
      notifies :reload, 'ohai[reload_packages]', :immediately
    end
  end
end

if platform_family?('suse')
  package 'logrotate'
  package 'socat'

  # rabbitmq-server-plugins needs to be first so they both get installed
  # from the right repository. Otherwise, zypper will stop and ask for a
  # vendor change.
  package 'rabbitmq-server-plugins' do
    action :install
    version node['rabbitmq']['version']
  end
  package 'rabbitmq-server' do
    action :install
    version node['rabbitmq']['version'] if node['rabbitmq']['pin_distro_version']
    notifies :reload, 'ohai[reload_packages]', :immediately
  end
end

if platform_family?('smartos')
  package 'rabbitmq' do
    action :install
    version node['rabbitmq']['version'] if node['rabbitmq']['pin_distro_version']
  end

  service 'epmd' do
    action :start
  end
end

#
# Users and directories
#

if platform_family?('amazon')
  user 'rabbitmq' do
    username node['rabbitmq']['user']
    shell '/sbin/nologin'
    home '/var/lib/rabbitmq'
    action :create
  end

  group 'rabbitmq' do
    group_name node['rabbitmq']['group']
    members [node['rabbitmq']['user']]
    action :manage
  end
end

if node['rabbitmq']['logdir']
  directory node['rabbitmq']['logdir'] do
    owner 'rabbitmq'
    group 'rabbitmq'
    mode '775'
    recursive true
  end
end

directory node['rabbitmq']['mnesiadir'] do
  owner 'rabbitmq'
  group 'rabbitmq'
  mode '775'
  recursive true
end

template "#{node['rabbitmq']['config_root']}/rabbitmq-env.conf" do
  source 'rabbitmq-env.conf.erb'
  cookbook node['rabbitmq']['config-env_template_cookbook']
  owner 'root'
  group 'root'
  mode '644'
  notifies :restart, "service[#{node['rabbitmq']['service_name']}]"
  variables(
    :config_path => rabbitmq_config_file_path
  )
end

template rabbitmq_config_file_path do
  sensitive true if Gem::Version.new(Chef::VERSION.to_s) >= Gem::Version.new('11.14.2')
  source 'rabbitmq.config.erb'
  cookbook node['rabbitmq']['config_template_cookbook']
  owner 'root'
  group 'root'
  mode '644'
  variables(
    :kernel => format_kernel_parameters,
    :ssl_versions => (format_ssl_versions if node['rabbitmq']['ssl_versions']),
    :ssl_ciphers => (format_ssl_ciphers if node['rabbitmq']['ssl_ciphers'])
  )
  notifies :restart, "service[#{node['rabbitmq']['service_name']}]"
end

template "/etc/default/#{node['rabbitmq']['service_name']}" do
  source 'default.rabbitmq-server.erb'
  owner 'root'
  group 'root'
  mode '644'
  notifies :restart, "service[#{node['rabbitmq']['service_name']}]"
end

existing_erlang_key = if File.exist?(node['rabbitmq']['erlang_cookie_path']) && File.readable?((node['rabbitmq']['erlang_cookie_path']))
                        File.read(node['rabbitmq']['erlang_cookie_path']).strip
                      else
                        ''
                      end

if node['rabbitmq']['clustering']['enable'] && (node['rabbitmq']['erlang_cookie'] != existing_erlang_key)
  log "stop #{node['rabbitmq']['service_name']} to change erlang cookie" do
    notifies :stop, "service[#{node['rabbitmq']['service_name']}]", :immediately
  end

  template node['rabbitmq']['erlang_cookie_path'] do
    source 'doterlang.cookie.erb'
    owner 'rabbitmq'
    group 'rabbitmq'
    mode '400'
    sensitive true
    notifies :start, "service[#{node['rabbitmq']['service_name']}]", :immediately
    notifies :run, 'execute[reset-node]', :immediately
  end

  # Need to reset for clustering #
  execute 'reset-node' do
    command 'rabbitmqctl stop_app && rabbitmqctl reset && rabbitmqctl start_app'
    action :nothing
    retries 12
    retry_delay 5
  end
end

if manage_rabbitmq_service?
  service node['rabbitmq']['service_name'] do
    retries node['rabbitmq']['retry']
    retry_delay node['rabbitmq']['retry_delay']
    action [:enable, :start]
    supports :status => true, :restart => true

    provider Chef::Provider::Service::Upstart if service_control_upstart?
    provider Chef::Provider::Service::Init    if service_control_init?
    provider Chef::Provider::Service::Systemd if service_control_systemd?
  end
else
  service node['rabbitmq']['service_name'] do
    action :nothing
  end
end

# after installing rabbitmq-server, reload the 'packages' automatic attributes
# from ohai. The version is used when deciding what release series-specific
# features can bee used.
ohai 'reload_packages' do
  action :nothing
  plugin 'packages'
end
