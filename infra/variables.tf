#VPC VARIABLES

variable "VPC_CIDR" {
  type = string
  description = "CIDR Block for our VPC"
}

variable "private_subnet_A_CIDR" {
  type = string
  description = "CIDR Block for Private Subnet A"
}

variable "private_subnet_B_CIDR" {
  type = string
  description = "CIDR Block for Private Subnet B"
}

variable "public_subnet_A_CIDR" {
  type = string
  description = "CIDR Block for Public Subnet A"
}

variable "public_subnet_B_CIDR" {
  type = string
  description = "CIDR Block for Public Subnet A"
}

variable "vpc_region" {
    type = string
    description = "Region of our VPC"
}

##################################################################

#ACM
variable "domain_name" {
  type = string
  description = "Domain Name"
}

#ECS
variable "application-image-uri" {
  type = string
  description = "URL of image hosted in ECR"
}

variable "taskExecutionARN" {
  type = string
  description = "ARN of the IAM User with Task Execution policy permissions"
}

#Ports
variable "container_port" {
  type = string
  description = "Port Container is running on"
}

variable "host_port" {
  type = string
  description = "Port that is visible to outside of the docker container, for Fargate Container Port = Host Port "
}