#
# Cookbook Name:: rabbitmq
# Recipe:: default
#
# Copyright 2009, Benjamin Black
# Copyright 2009-2011, Opscode, Inc.
# Copyright 2012, Kevin Nuckolls <kevin.nuckolls@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

directory "/etc/rabbitmq/" do
  owner "root"
  group "root"
  mode 0755
  action :create
end

template "/etc/rabbitmq/rabbitmq-env.conf" do
  source "rabbitmq-env.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[rabbitmq-server]"
end

case node[:platform]
when "debian", "ubuntu"
  # use the RabbitMQ repository instead of Ubuntu or Debian's
  # because there are very useful features in the newer versions
  apt_repository "rabbitmq" do
    uri "http://www.rabbitmq.com/debian/"
    distribution "testing"
    components ["main"]
    key "http://www.rabbitmq.com/rabbitmq-signing-key-public.asc"
    action :add
    notifies :run, resources(:execute => "apt-get update"), :immediately
  end
  # installs the required setsid command -- should be there by default but just in case
  package "util-linux"
  package "rabbitmq-server"
when "redhat", "centos", "scientific", "amazon"
  remote_file "/tmp/rabbitmq-server-#{node[:rabbitmq][:version]}-1.noarch.rpm" do
    source "https://www.rabbitmq.com/releases/rabbitmq-server/v#{node[:rabbitmq][:version]}/rabbitmq-server-#{node[:rabbitmq][:version]}-1.noarch.rpm"
    action :create_if_missing
  end
  rpm_package "/tmp/rabbitmq-server-#{node[:rabbitmq][:version]}-1.noarch.rpm" do
    action :install
  end
end

unless File.exists?('/var/lib/rabbitmq/.custom_directories_set')
  
  execute "rabbitmq-stop" do
    command "setsid /etc/init.d/rabbitmq-server stop"
    action :run
  end
  
  if node[:rabbitmq][:data_directory] != '/var/lib/rabbitmq'
    directory node[:rabbitmq][:data_directory] do
      mode "0775"
      owner "rabbitmq"
      group "rabbitmq"
      action :create
      recursive true
    end
    
    bash "move-data-dir" do
      user "root"
      code <<-EOH
      mv /var/lib/rabbitmq #{node[:rabbitmq][:data_directory]}
      EOH
    end
  
    link "/var/lib/rabbitmq" do
      to node[:rabbitmq][:data_directory]
    end 
  end
  
  if node[:rabbitmq][:log_directory] != '/var/log/rabbitmq'
    directory node[:rabbitmq][:log_directory] do
      mode "0775"
      owner "rabbitmq"
      group "rabbitmq"
      action :create
      recursive true
    end
    
    bash "move-log-dir" do
      user "root"
      code <<-EOH
      mv /var/log/rabbitmq #{node[:rabbitmq][:log_directory]}
      EOH
    end
  
    link "/var/log/rabbitmq" do
      to node[:rabbitmq][:log_directory]
    end
  end
  
  execute "rabbitmq-start" do
    command "setsid /etc/init.d/rabbitmq-server start"
    action :run
  end
  
  bash "make-directory-changes-one-time-idempotent" do
    user "root"
    code <<-EOH
    touch /var/lib/rabbitmq/.custom_directories_set
    EOH
  end
end

if File.exists?('/var/lib/rabbitmq/.erlang.cookie')
  @existing_erlang_key =  File.read('/var/lib/rabbitmq/.erlang.cookie')
else
  @existing_erlang_key = ""
end

if node[:rabbitmq][:cluster] and node[:rabbitmq][:erlang_cookie] != @existing_erlang_key
    execute "rabbitmq-stop" do
      command "setsid /etc/init.d/rabbitmq-server stop"
      action :run
    end
    
    template "/var/lib/rabbitmq/.erlang.cookie" do
      source "doterlang.cookie.erb"
      owner "rabbitmq"
      group "rabbitmq"
      mode 0400
    end

    execute "rabbitmq-start" do
      command "setsid /etc/init.d/rabbitmq-server start"
      action :run
    end
end

template "/etc/rabbitmq/rabbitmq.config" do
  source "rabbitmq.config.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[rabbitmq-server]", :immediately
end

## You'll see setsid used in all the init statements in this cookbook. This 
## is because there is a problem with the stock init script in the RabbitMQ
## debian package (at least in 2.8.2) that makes it not daemonize properly 
## when called from chef. The setsid command forces the subprocess into a state 
## where it can daemonize properly. -Kevin (thanks to Daniel DeLeo for the help)

service "rabbitmq-server" do
  start_command "setsid /etc/init.d/rabbitmq-server start"
  stop_command "setsid /etc/init.d/rabbitmq-server stop"
  restart_command "setsid /etc/init.d/rabbitmq-server restart"
  status_command "setsid /etc/init.d/rabbitmq-server status"
  supports :status => true, :restart => true
  action [ :enable, :start ]
end
