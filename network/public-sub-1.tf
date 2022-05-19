resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.iti_vpc.id
  cidr_block = var.netowrk_public_subnet_1_cidr
  availability_zone = var.netowrk_az1
  # to assign public ip to included instances
  map_public_ip_on_launch = true   
  tags = {
    Name = "public-subnet-1"
  }
}