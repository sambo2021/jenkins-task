resource "aws_security_group" "securitygroup" {
  name = "PrivateSecurityGroup"
  description = "PrivateSecurityGroup"
  vpc_id = aws_vpc.iti_vpc.id
  #allowing only ssh from outside
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
   ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
  }
   ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
  }
   ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
  }
  ingress {
     description="https"
     cidr_blocks = ["0.0.0.0/0"]
     from_port = 443
     to_port = 443
     protocol = "tcp"
  }
   #allowing going to outside
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  tags = {
    "Name" = "PrivateSecurityGroup"
  }
}