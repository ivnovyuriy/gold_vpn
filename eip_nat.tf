resource "aws_eip" "my-eip" {
  instance = aws_instance.vpn-server.id
  vpc      = true
}

# # Elastic IP created in AWS web interface

# data "aws_eip" "eip_by_filter" {
#   filter {
#     name   = "tag:Name"
#     values = ["EIP"] # Name of EIP in web interface
#   }
# }

# # Associate an EIP to an EC2 instance (creating by terraform)

# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = aws_instance.vpn-server.id
#   allocation_id = data.aws_eip.eip_by_filter.id
# }

# NAT GateWay

# resource "aws_nat_gateway" "nat_gw" {
#   allocation_id = "eipalloc-0d24a776cbe8f60be"
#   subnet_id     = aws_subnet.main-public-1.id
#   tags = {
#     "Name" = "Nat GateWay"
#   }

# }