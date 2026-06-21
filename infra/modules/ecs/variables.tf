variable "application-image-uri" {
  type        = string
  description = "The URL of the image hosted in ECR"
}

variable "taskExecutionARN" {
  type = string
  description = "ARN of the IAM User with Task Execution policy permissions"
}

variable "target_group_arn" {
  type = string
  description = "Load Balancer ARN"
}

variable "private_subnets" {
  type = list(string)
  description = "Private Subnets"
}

variable "security_group" {
  type = string
  description = "Security Group ID"
}

variable "container_port" {
  type = string
  description = "Port Container is running on"
}

variable "host_port" {
  type = string
  description = "Port that is visible to outside of the docker container, for Fargate Container Port = Host Port "
}