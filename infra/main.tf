data "aws_acm_certificate" "memos-acm" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
}

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
    public_subnets_id = module.vpc.public_subnets_id
    acm-arn = data.aws_acm_certificate.memos-acm.arn
    ecs-cluster-arn = module.ecs.memos-ecs-cluster
    vpc_id = module.vpc.vpc_id
}

module "security_group" {
    source = "./modules/sg"
    vpc_id_sg = module.vpc.vpc_id
}

module "ecs" {
  source = "./modules/ecs"
  application-image-uri = var.application-image-uri
  taskExecutionARN = var.taskExecutionARN
  target_group_arn = module.alb.target_group_arn
  memos_ecs_tasks_sg = module.security_group.memos_ecs_tasks_sg_id
  private_subnets = module.vpc.private_subnets_id
  container_port = var.container_port
  host_port = var.host_port
}

module "route53" {
  source = "./modules/route53"
  alb_zone_id = module.alb.alb_zone_id
  alb_dns_name = module.alb.alb_dns_name
}