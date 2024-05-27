provider "aws" {
  region     = "us-west-2"
  access_key = "YOUR_ACCESS_KEY"    # Replace with your actual access key
  secret_key = "YOUR_SECRET_KEY"    # Replace with your actual secret key
}


module "network" {
  source = "./modules/network"
}

module "rds" {
  source = "./modules/rds"
}

module "ecs" {
  source = "./modules/ecs"
}

module "alb" {
  source = "./modules/alb"
}

module "waf" {
  source = "./modules/waf"
}
