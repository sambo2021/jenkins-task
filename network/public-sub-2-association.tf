#associate routing to internet gatway
resource "aws_route_table_association" "public-subnet-2-route-table-association" {
  subnet_id = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-route-table.id
}