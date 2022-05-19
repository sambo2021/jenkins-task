resource "aws_security_group" "publicsecuritygroup" {
  name = "PublicSecurityGroup"
  description = "PublicSecurityGroup"
  vpc_id = aws_vpc.iti_vpc.id
  #allowing only ssh from outside
  ingress {
    description="ssh"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
    ingress {
     description="http"
     cidr_blocks = ["0.0.0.0/0"]
     from_port = 80
     to_port = 80
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
    "Name" = "PublicSecurityGroup"
  }
}