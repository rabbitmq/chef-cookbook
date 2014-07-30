@test "rabbitmqctl status runs successfully" {
  run sudo su - root -c "/usr/sbin/rabbitmqctl status"
}
