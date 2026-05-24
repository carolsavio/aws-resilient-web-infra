output "web_sg_id" {
  value = aws_security_group.web_sg.id
}

output "iam_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}