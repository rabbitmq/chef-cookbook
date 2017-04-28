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
