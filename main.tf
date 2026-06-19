module "network" {
  source = "./modules/network"

  project_name = var.project_name
  vpc_cidr     = var.vpc_cidr
  az_a         = var.az_a
  az_b         = var.az_b
  common_tags  = local.common_tags
}

module "security" {
  source = "./modules/security"

  project_name = var.project_name
  vpc_id       = module.network.vpc_id
  common_tags  = local.common_tags
}

module "load_balancer" {
  source = "./modules/load_balancer"

  project_name          = var.project_name
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_alb_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  common_tags           = local.common_tags
}

module "compute" {
  source = "./modules/compute"

  project_name                  = var.project_name
  instance_type                 = var.instance_type
  private_app_subnet_ids        = module.network.private_app_subnet_ids
  frontend_security_group_id    = module.security.frontend_security_group_id
  backend_security_group_id     = module.security.backend_security_group_id
  frontend_target_group_arn     = module.load_balancer.frontend_target_group_arn
  backend_target_group_arn      = module.load_balancer.backend_target_group_arn
  frontend_google_drive_file_id = var.frontend_google_drive_file_id
  frontend_desired_capacity     = var.frontend_desired_capacity
  frontend_min_size             = var.frontend_min_size
  frontend_max_size             = var.frontend_max_size
  backend_desired_capacity      = var.backend_desired_capacity
  backend_min_size              = var.backend_min_size
  backend_max_size              = var.backend_max_size
  common_tags                   = local.common_tags
}

module "database" {
  source = "./modules/database"

  project_name          = var.project_name
  private_db_subnet_ids = module.network.private_db_subnet_ids
  rds_security_group_id = module.security.rds_security_group_id
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  db_instance_class     = var.db_instance_class
  common_tags           = local.common_tags
}
