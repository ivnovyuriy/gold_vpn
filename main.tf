terraform {
  backend "s3" {
    bucket = "my-goldvpn-bucket"
    key    = "gold_vpn_state"
    region = "us-east-1"
  }
}