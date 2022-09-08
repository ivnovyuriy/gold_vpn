# Elastic IP

resource "aws_eip" "nat1" {
  depends_on = [aws_internet_gateway.main-gw]
  tags = {
    Name = "EIP"
  }

}

# NAT GateWay

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.main-public-1.id
  tags = {
    "Name" = "Nat GateWay"
  }

}