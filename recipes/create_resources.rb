data_bag("rabbitmq_vhosts").each do |item_name|
  item = data_bag_item("rabbitmq_vhosts", item_name)
  rabbitmq_vhost item["path"] do
    action :add
  end
end

data_bag("rabbitmq_users").each do |item_name|
  item = data_bag_item("rabbitmq_users", item_name)
  user_password = Chef::EncryptedDataBagItem.load("rabbitmq_passwords", item["username"])["password"]

  rabbitmq_user item["username"] do
    password user_password
    action :add
    tags item["tags"]
  end

  item["permission_definitions"].each do |perm|
    rabbitmq_user item["username"] do
      action :set_permissions
      vhost perm["vhost"]
      permissions perm["permissions"]
    end
  end
end
