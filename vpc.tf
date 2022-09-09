# Internet VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "main"
  }
}

# Internet GW
resource "aws_internet_gateway" "main-gw" {
  depends_on = [
    aws_vpc.main,
    aws_subnet.main-public-1,
    aws_subnet.main-private-1
  ]
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main"
  }
}

# Subnets
resource "aws_subnet" "main-public-1" {
  vpc_id                  = aws_vpc.main.id
  depends_on              = [aws_vpc.main]
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "main-private-1" {
  vpc_id = aws_vpc.main.id
  depends_on = [
    aws_vpc.main,
    aws_subnet.main-public-1
  ]
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Private Subnet"
  }
}

# route tables
resource "aws_route_table" "rt" {
  depends_on = [
    aws_vpc.main,
    aws_internet_gateway.main-gw
  ]
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-gw.id
  }
  tags = {
    Name = "main-public-1"
  }
}

# route associations public
resource "aws_route_table_association" "rt-assoc" {
  depends_on = [
    aws_vpc.main,
    aws_subnet.main-public-1,
    aws_subnet.main-private-1,
    aws_route_table.rt
  ]

  subnet_id      = aws_subnet.main-public-1.id
  route_table_id = aws_route_table.rt.id
}




