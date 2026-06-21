variable "security_group_id" {
  type = string
  description = "Security Group for ALB/Network"
}

variable "subnets_for_alb" {
  type = list(string)
  description = "public subnets for ALB"
}