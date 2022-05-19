resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.iti_vpc.id
  tags = {
    Name = "iti-getway"
  }
}