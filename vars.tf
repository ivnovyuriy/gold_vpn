variable "AWS_REGION" {
  default = "us-east-1"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-0a24ce26f4e187f9a"
  }
}

# Don't assign a public IP address by default
variable "associate_public_ip_address" {
  default = true
}


# variable public_eip {
#     description = "A pre-assigned public (elastic) (eip) IP address"
#     default = "eipalloc-03361115d3287245f"
# }
