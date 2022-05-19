resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.iti_vpc.id
  cidr_block = var.netowrk_public_subnet_2_cidr
  availability_zone = var.netowrk_az2
  # to assign public ip to included instances
  map_public_ip_on_launch = true   
  tags = {
    Name = "public-subnet-2"
  }
}