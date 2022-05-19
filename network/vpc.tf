# Create a VPC
resource "aws_vpc" "iti_vpc" {
  cidr_block           = var.netowrk_vbc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.netowrk_name
    Env  = "devops"
  }
}