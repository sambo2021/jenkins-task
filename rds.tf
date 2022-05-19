
resource "aws_db_subnet_group" "default" {
  name       = "database subnets"
  subnet_ids = [module.iti.network_private_subnet_1_id, module.iti.network_private_subnet_2_id]
  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "iti-rds" {
  identifier             = "iti-rds-education"
  name                   = var.db_name
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  db_subnet_group_name   = aws_db_subnet_group.default.name
  username               = var.rds_username
  password               = var.rds_password
  vpc_security_group_ids = [module.iti.network_private_security_group_id ]
  parameter_group_name   = "default.mysql5.7"
  availability_zone      = var.az1
  port                   = "3306"
  #deletion_protection    = true
  skip_final_snapshot    = true

}

