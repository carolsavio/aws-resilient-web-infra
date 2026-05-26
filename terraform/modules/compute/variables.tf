variable "subnet_id" { type = string }
variable "security_group_ids" { type = list(string) }
variable "iam_instance_profile" { type = string }

variable "zabbix_sg_id" { type = string }
variable "zabbix_instance_profile_name" { type = string }