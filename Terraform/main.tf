terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Select provider
provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "fbayomide-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "fbayomide-vpc"
  }
}

# Create Internet Gateway

resource "aws_internet_gateway" "fbayomide-internet-gateway" {
  vpc_id = aws_vpc.fbayomide-vpc.id
  tags = {
    Name = "fbayomide-internet-gateway"
  }
}

# Create public Route Table
resource "aws_route_table" "fbayomide-route-table-public" {
  vpc_id = aws_vpc.fbayomide-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fbayomide-internet-gateway.id
  }
  tags = {
    Name = "fbayomide-route-table-public"
  }
}

# Create Public Subnet-1
resource "aws_subnet" "fbayomide-public-subnet1" {
  vpc_id                  = aws_vpc.fbayomide-vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "fbayomide-public-subnet1"
  }
}
# Create Public Subnet-2
resource "aws_subnet" "fbayomide-public-subnet2" {
  vpc_id                  = aws_vpc.fbayomide-vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "fbayomide-public-subnet2"
  }
}

# Associate public subnet 1 with public route table
resource "aws_route_table_association" "fbayomide-public-subnet1-association" {
  subnet_id      = aws_subnet.fbayomide-public-subnet1.id
  route_table_id = aws_route_table.fbayomide-route-table-public.id
}

# Associate public subnet 2 with public route table
resource "aws_route_table_association" "fbayomide-public-subnet2-association" {
  subnet_id      = aws_subnet.fbayomide-public-subnet2.id
  route_table_id = aws_route_table.fbayomide-route-table-public.id
}

# Create a Network ACL

resource "aws_network_acl" "fbayomide-network_acl" {
  vpc_id     = aws_vpc.fbayomide-vpc.id
  subnet_ids = [aws_subnet.fbayomide-public-subnet1.id, aws_subnet.fbayomide-public-subnet2.id]

 ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}