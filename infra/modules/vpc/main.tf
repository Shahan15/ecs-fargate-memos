#VPC
resource "aws_vpc" "memos-vpc" {
  cidr_block = var.VPC_CIDR
}

##PRIVATE SUBNETS
resource "aws_subnet" "memos-private-subnet-A" {
  vpc_id            = aws_vpc.memos-vpc.id
  cidr_block        = var.private_subnet_A_CIDR
  availability_zone = "${var.vpc_region}a"

  tags = {
    Name = "Private_SubnetA"
  }
  map_public_ip_on_launch = false
}


resource "aws_subnet" "memos-private-subnet-B" {
  vpc_id            = aws_vpc.memos-vpc.id
  cidr_block        = var.private_subnet_B_CIDR
  availability_zone = "${var.vpc_region}b"

  tags = {
    Name = "Private_SubnetB"
  }
  map_public_ip_on_launch = false

}

#PUBLIC SUBNETS
resource "aws_subnet" "memos-public-subnet-A" {
  vpc_id            = aws_vpc.memos-vpc.id
  cidr_block        = var.public_subnet_A_CIDR
  availability_zone = "${var.vpc_region}a"


  tags = {
    Name = "Public_SubnetA"
  }
  map_public_ip_on_launch = true
}

resource "aws_subnet" "memos-public-subnet-B" {
  vpc_id            = aws_vpc.memos-vpc.id
  cidr_block        = var.public_subnet_B_CIDR
  availability_zone = "${var.vpc_region}b"

  tags = {
    Name = "Public_SubnetB"
  }
  map_public_ip_on_launch = true
}


#INTERNET GATEWAY
resource "aws_internet_gateway" "memos-internet_gateway" {
  vpc_id = aws_vpc.memos-vpc.id

  tags = {
    Name = "Internet_Gateway"
  }
}


#Static IP
resource "aws_eip" "IP_FOR_Nat_A" {
  domain = "vpc"
  tags = {
    Name = "EIP_A"
  }

  depends_on = [aws_internet_gateway.memos-internet_gateway]

}

resource "aws_eip" "IP_FOR_Nat_B" {
  domain = "vpc"
  tags = {
    Name = "EIP_B"
  }
  depends_on = [aws_internet_gateway.memos-internet_gateway]
}


#NAT GATEWAY
resource "aws_nat_gateway" "nat_A" {
  allocation_id = aws_eip.IP_FOR_Nat_A.id
  subnet_id     = aws_subnet.memos-public-subnet-A.id
  tags = {
    Name = "NAT_G-A"
  }
}

resource "aws_nat_gateway" "nat_B" {
  allocation_id = aws_eip.IP_FOR_Nat_B.id
  subnet_id     = aws_subnet.memos-public-subnet-B.id
  tags = {
    Name = "NAT_G-B"
  }
}


#ROUTE TABLES

#PUBLIC ROUTE
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.memos-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.memos-internet_gateway.id
  }

  tags = {
    Name = "Public_Route"
  }
}

#PRIVATE ROUTE
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.memos-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_A.id
  }

  tags = {
    Name = "Private_Route"
  }
}

# Public Table Linkage to Public Subnets
resource "aws_route_table_association" "public_assoc_A" {
  subnet_id      = aws_subnet.memos-public-subnet-A.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public_assoc_B" {
  subnet_id      = aws_subnet.memos-public-subnet-B.id
  route_table_id = aws_route_table.public_route.id
}

# Private Table Linkage to Private Subnets
resource "aws_route_table_association" "private_assoc_A" {
  subnet_id      = aws_subnet.memos-private-subnet-A.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private_assoc_B" {
  subnet_id      = aws_subnet.memos-private-subnet-B.id
  route_table_id = aws_route_table.private_route.id
}
