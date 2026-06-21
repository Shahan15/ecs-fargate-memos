module "vpc" {
  source = "./modules/vpc"
  vpc_region = var.vpc_region
  VPC_CIDR = var.VPC_CIDR
  private_subnet_A_CIDR = var.private_subnet_A_CIDR
  private_subnet_B_CIDR = var.private_subnet_B_CIDR
  public_subnet_A_CIDR = var.public_subnet_A_CIDR
  public_subnet_B_CIDR = var.public_subnet_B_CIDR
}

module "alb" {
    source = "./modules/alb"
    security_group_id = module.security_group.sg_id
    subnets_for_alb = module.vpc.public_subnets
}

module "security_group" {
    source = "./modules/sg"
    vpc_id_sg = module.vpc.vpc_id
}