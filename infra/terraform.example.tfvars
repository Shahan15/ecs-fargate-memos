vpc_region = ""
VPC_CIDR = ""
private_subnet_A_CIDR = ""
private_subnet_B_CIDR = ""
public_subnet_A_CIDR = ""
public_subnet_B_CIDR = ""

#ALB
subnets_for_alb = [""]

#ACM
domain_name = ""

#ECS
#Image URI hosted in ECR
application-image-uri  = ""
#ARN of the user with task execution permissions
taskExecutionARN = ""
#Port your Container is hosted on
container_port = 
#Port of the host - this will be the same as Container-port if launch type = fargate
host_port = 