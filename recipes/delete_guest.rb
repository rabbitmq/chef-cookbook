if node["rabbitmq"]["delete_guest"]
	rabbitmq_user "guest" do
		action :delete
	end
	Chef::Log.info "Deleted RabbitMQ guest account"
elsif not node["rabbitmq"]["guest_password"].empty?
	bash "reset guest password" do
		user "root"
		code <<-EOH
			rabbitmqctl change_password guest #{node["rabbitmq"]["guest_password"]} 
		EOH
	end
	Chef::Log.info "Reset password for RabbitMQ guest account"
end
