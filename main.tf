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
}

module "alb" {
  source     = "./modules/alb"
  subnet_ids = module.network.public_subnet_ids
  vpc_id     = module.network.vpc_id
}

module "ecs" {
  source       = "./modules/ecs"
  subnet_ids   = module.network.public_subnet_ids
  vpc_id       = module.network.vpc_id
  rds_endpoint = module.rds.rds_endpoint
}

module "waf" {
  source = "./modules/waf"
  alb_arn = module.alb.alb_arn
}
