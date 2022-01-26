#Add output web-server instans-id 
output "webserver_instance_id" {
  value = aws_instance.my_webserver.id
}

#Add output web-server public IP
output "webserver_public_ip" {
  value = aws_eip.my_static_ip.public_ip
  # description not see in output
  description = "Web server ip" 
}

