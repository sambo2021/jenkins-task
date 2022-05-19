resource "aws_route_table" "public-route-table" {
  vpc_id     = aws_vpc.iti_vpc.id
 route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.gw.id
 } 
  tags = {
    Name = "public-route-table"
  }
}