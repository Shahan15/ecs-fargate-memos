#VPC VARIABLES

variable "VPC_CIDR" {
  type        = string
  description = "CIDR Block for our VPC"
}

variable "private_subnet_A_CIDR" {
  type        = string
  description = "CIDR Block for Private Subnet A"
}

variable "private_subnet_B_CIDR" {
  type        = string
  description = "CIDR Block for Private Subnet B"
}

variable "public_subnet_A_CIDR" {
  type        = string
  description = "CIDR Block for Public Subnet A"
}

variable "public_subnet_B_CIDR" {
  type        = string
  description = "CIDR Block for Public Subnet A"
}

variable "vpc_region" {
  type        = string
  description = "Region of our VPC"
}

##################################################################

#ACM
variable "domain_name" {
  type        = string
  description = "Domain Name"
}

variable "sub_domain" {
  type = string
  description = "Sub Domain"
}


#CLOUDFLARE
variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare Account API Token"
  sensitive   = true
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
  sensitive = true
}



#ECS
variable "ecr_registry_url" {
  type        = string
  description = "ECR Registry URL"
}

#PORTS
variable "container_port" {
  type        = string
  description = "Port Container is running on"
}

variable "host_port" {
  type        = string
  description = "Port that is visible to outside of the docker container, for Fargate Container Port = Host Port "
}


#GITHUB PARAMETERS
variable "repository" {
  type        = string
  description = "Repo of where the project"
  default     = "ecs-memos-fargate"
}

variable "organistaion_name" {
  type = string
  description = "Github username or organisation owning target repo"
  default = "Shahan15"
}
