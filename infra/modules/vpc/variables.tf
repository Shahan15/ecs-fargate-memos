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
