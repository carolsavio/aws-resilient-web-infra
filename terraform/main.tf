module "network" {
  source = "./modules/network"
}

module "storage" {
  source       = "./modules/storage"
  project_name = var.project_name
}

module "security" {
  source     = "./modules/security"
  vpc_id     = module.network.vpc_id
  bucket_arn = module.storage.bucket_arn
}

module "compute" {
  source               = "./modules/compute"
  subnet_id            = module.network.subnet_id
  security_group_ids   = [module.security.web_sg_id]
  iam_instance_profile = module.security.iam_instance_profile_name

  zabbix_sg_id                 = module.security.zabbix_sg_id
  zabbix_instance_profile_name = module.security.zabbix_instance_profile_name
}