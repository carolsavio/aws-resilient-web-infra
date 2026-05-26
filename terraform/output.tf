output "web_server_public_ip" {
  description = "IP Público para acessar o Apache"
  value       = module.compute.web_public_ip
}

output "s3_bucket_name" {
  description = "Nome do bucket gerado para configurar no script Python"
  value       = module.storage.bucket_name
}