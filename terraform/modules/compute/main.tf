resource "aws_instance" "web" {
  ami                    = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS (us-east-1)
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile   = var.iam_instance_profile

  tags = { Name = "Apache-Web-Server" }
}

resource "aws_instance" "zabbix" {
  ami                    = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS (us-east-1)
  instance_type          = "t3.small"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.zabbix_sg_id]
  iam_instance_profile   = var.zabbix_instance_profile_name

  tags = { Name = "Zabbix-Server" }
}