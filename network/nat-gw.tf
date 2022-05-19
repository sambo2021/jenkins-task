#creating nat getway and attach it to public subnet
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic-ip.id
  subnet_id = aws_subnet.public-subnet-1.id
  tags = {
    "Name" = "nat-getway"
  }
}
