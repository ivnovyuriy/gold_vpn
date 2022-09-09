# Elastic IP

resource "aws_eip" "nat1" {
  depends_on = [aws_internet_gateway.main-gw]
  tags = {
    Name = "EIP"
  }

}

# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = aws_instance.vpn-server.id
#   allocation_id = "eipalloc-0d24a776cbe8f60be"
# }

# NAT GateWay

# resource "aws_nat_gateway" "nat_gw" {
#   allocation_id = "eipalloc-0d24a776cbe8f60be"
#   subnet_id     = aws_subnet.main-public-1.id
#   tags = {
#     "Name" = "Nat GateWay"
#   }

# }