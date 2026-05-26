output "web_public_ip" {
  value = aws_instance.web.public_ip
}

output "zabbix_public_ip" {
  value = aws_instance.zabbix.public_ip
}

output "zabbix_instance_id" {
  value = aws_instance.zabbix.id
}

output "web_instance_id" {
  value = aws_instance.web.id
}