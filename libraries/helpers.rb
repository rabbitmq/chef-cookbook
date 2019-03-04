module RabbitMQCookbook
  module Helpers
    require 'mixlib/shellout'

    def reset_current_node
      # stop rmq
      stop_rmq = Mixlib::ShellOut.new('rabbitmqctl stop_app')
      stop_rmq.run_command
      stop_rmq.error!
      # remove self from cluster
      reset_rmq = Mixlib::ShellOut.new('rabbitmqctl reset')
      reset_rmq.run_command
      reset_rmq.error!
    end

    def remove_remote_node_from_cluster(rmq_node)
      remove_from_cluster = Mixlib::ShellOut.new("rabbitmqctl forget_cluster_node #{rmq_node}")
      remove_from_cluster.run_command
      remove_from_cluster.error!
    end
  end
end

def rabbitmq_version
  node['rabbitmq']['version'].to_s
end

def rabbitmq_38?
  rabbitmq_version =~ /^3.8/
end

def rabbitmq_37?
  rabbitmq_version =~ /^3.7/
end

def rabbitmq_36?
  rabbitmq_version =~ /^3.6/
end

def rabbitmq_config_file_path
  configured_path = node['rabbitmq']['config']

  # 3.6.x does not support .config in RABBITMQ_CONFIG_FILE paths. MK.
  if ::File.extname(configured_path).empty? && !rabbitmq_36?
    "#{configured_path}.config"
  else
    configured_path
  end
end
