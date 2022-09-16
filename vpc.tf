# Internet VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    Name = "mainVPC"
  }
}

# Internet GW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "mainGW"
  }
}

resource "aws_eip" "my_eip" {
  vpc = true
  tags = {
    Name = "MyEIP"
  }
}

resource "aws_eip_association" "my_eip_association" {

  instance_id   = aws_instance.vpn-server.id
  allocation_id = aws_eip.my_eip.id
}

# Subnets
resource "aws_subnet" "main_public_1" {
  vpc_id                  = aws_vpc.main.id
  depends_on              = [aws_vpc.main]
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "Public Subnet"
  }
}

# route tables
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "RT"
  }
}

# route associations public
resource "aws_route_table_association" "rt-assoc" {
  subnet_id      = aws_subnet.main_public_1.id
  route_table_id = aws_route_table.rt.id
}




