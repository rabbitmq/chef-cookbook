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

def rabbitmq_package_download_base_url
  case node['rabbitmq']['package_source'].to_s.downcase
  when :github, /github/i
    "https://github.com/rabbitmq/rabbitmq-server/releases/download/v#{rabbitmq_version}/"
  when :bintray, /bintray/i
    "https://dl.bintray.com/rabbitmq/all/rabbitmq-server/#{rabbitmq_version}/"
  else
    "https://github.com/rabbitmq/rabbitmq-server/releases/download/v#{rabbitmq_version}/"
  end
end

def rabbitmq_config_file_path
  configured_path = node['rabbitmq']['config']

  # If no extension is configured, append it.
  if ::File.extname(configured_path).empty?
    "#{configured_path}.config"
  else
    configured_path
  end
end
