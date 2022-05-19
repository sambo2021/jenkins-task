resource "aws_subnet" "private-subnet-2" {
  cidr_block = var.netowrk_private_subnet_2_cidr
  vpc_id = aws_vpc.iti_vpc.id
  availability_zone = var.netowrk_az2
  map_public_ip_on_launch = false   
  tags = {
    "Name" = "private-subnet-2"
  }
}