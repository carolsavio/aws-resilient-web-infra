output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "zabbix_sg_id" {
  value = aws_security_group.zabbix_sg.id
}

output "zabbix_instance_profile_name" {
  value = aws_iam_instance_profile.zabbix_profile.name
}