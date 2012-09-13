unless File.exists?('/var/lib/rabbitmq/.reset_mnesia_database')
	disk_nodes = search(:node, "role:rabbitdisknode AND chef_environment:#{node.chef_environment}")
	unless disk_nodes.empty? || disk_nodes.nil?
		disk_nodes = Set.new disk_nodes

		disk_node_string = "rabbit@" + disk_nodes.map { |node| node.name }.join(" rabbit@")
		if disk_node_string != "rabbit@#{node.name}"
			`rabbitmqctl cluster_status > /dev/null 2>&1`

			if $? != 0
				execute "rabbitmqctl stop_app"
				execute "rabbitmqctl reset"
				execute "rabbitmqctl cluster #{disk_node_string}"
				execute "rabbitmqctl start_app"
			end
		end
	end
end
