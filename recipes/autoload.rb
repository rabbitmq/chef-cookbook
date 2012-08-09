vhosts = data_bag("rabbitmq_vhost").map do |item_id|
  vhost = data_bag_item("rabbitmq_vhost", item_id)
  rabbitmq_vhost vhost["path"] do
    action :add
  end
end

users = data_bag("rabbitmq_user").map do |item_id|
  user = data_bag_item("rabbitmq_user", item_id)
  rabbitmq_user user["username"] do
    password user["password"] #TODO: make this encrypted data bag
    action :add
  end

  user["permissions"].each do |entry|
    rabbitmq_user user["username"] do
      vhost entry["vhost"]
      permissions entry["permissions"]
      action :set_permissions
    end
  end
end
