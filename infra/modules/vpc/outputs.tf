output "vpc_id" {
  value = aws_vpc.memos-vpc.id
  description = "The ID of memos-VPC"
}

output "private_subnet_A_id" {
  value = aws_subnet.memos-private-subnet-A.id
  description = "The ID of private subnet A"
}

output "private_subnet_B_id" {
  value = aws_subnet.memos-private-subnet-B.id
  description = "The ID of private subnet B"
}

output "public_subnets" {
  value = [aws_subnet.memos-public-subnet-A.id,aws_subnet.memos-public-subnet-B.id]
}

output "internet_gateway_id" {
  value = aws_internet_gateway.memos-internet_gateway.id
  description = "The ID of the Internet Gateway"
}