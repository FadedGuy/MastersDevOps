module "network" {
  source = "./modules/network"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}

module "compute" {
  source             = "./modules/compute"
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  app_ami_name_tag   = var.app_ami_name_tag
  mongo_ami_name_tag = var.mongo_ami_name_tag
  instance_type      = var.instance_type
  key_name           = var.key_name
  app_sg_id          = module.security.app_sg_id
  mongodb_sg_id      = module.security.mongodb_sg_id
}

module "load_balancer" {
  source = "./modules/load_balancer"

  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  app_sg_id         = module.security.app_sg_id
  alb_sg_id         = module.security.alb_sg_id
  target_instance_ids = {
    app1 = module.compute.app_instance_id
  }
}

