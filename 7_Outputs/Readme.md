**Outputs**

Вывод результатов terraform (например IP,Instance-id)

*Output'ы лучше держать в отдельном файле*

Примеры:

```hcl
#Add output web-server instans-id 
output "webserver_instance_id" {
  value = aws_instance.my_webserver.id
}

#Add output web-server public IP
output "webserver_public_ip" {
  value = aws_eip.my_static_ip.public_ip
}
```

Посмотреть предыдущий output: `terraform output`

Посмотреть список всех параметров, которые можно отправить в Output: `terraform show`