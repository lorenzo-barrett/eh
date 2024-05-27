provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

module "network" {
  source = "./modules/network"
}

module "rds" {
  source     = "./modules/rds"
  subnet_ids = module.network.public_subnet_ids
  vpc_id     = module.network.vpc_id
  depends_on = [module.network]
}

module "alb" {
  source     = "./modules/alb"
  subnet_ids = module.network.public_subnet_ids
  vpc_id     = module.network.vpc_id
  depends_on = [module.network]
}

module "ecs" {
  source           = "./modules/ecs"
  subnet_ids       = module.network.public_subnet_ids
  vpc_id           = module.network.vpc_id
  rds_endpoint     = module.rds.rds_endpoint
  security_group_id = module.alb.security_group_id
  target_group_arn  = module.alb.target_group_arn
  alb_listener_arn  = module.alb.alb_arn
  depends_on       = [module.network, module.rds, module.alb]
}

module "waf" {
  source = "./modules/waf"
  alb_arn = module.alb.alb_arn
  depends_on = [module.alb]
}
