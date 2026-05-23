variable "aws_region" {
  description = "Região da AWS para provisionar os recursos"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome base para as tags dos recursos"
  type        = string
  default     = "Lab-Resilient"
}