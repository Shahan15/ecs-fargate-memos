variable "security_group_id" {
  type = string
  description = "Security Group for ALB/Network"
}

variable "public_subnets_id" {
  type = list(string)
  description = "public subnets for ALB"
}

variable "vpc_id" {
  type = string
  description = "VPC ID"
}

variable "acm-arn" {
  type = string
  description = "ACM Certificate ARN"
}

variable "ecs-cluster-arn" {
  type = string
  description = "ARN of the deployed ECS Cluster"
}