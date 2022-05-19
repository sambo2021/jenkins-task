resource "aws_elasticache_subnet_group" "default"{
    name = "ecs-sbnets-group"
    subnet_ids = [module.iti.network_private_subnet_1_id , module.iti.network_private_subnet_2_id]
    tags = {
    Name = "My elastic cash  DB subnet group"
  }
}

resource "aws_elasticache_cluster" "example" {
  cluster_id           = "redis-cluster"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = "6379"
  availability_zone    = var.az1
  security_group_ids   = [module.iti.network_private_security_group_id]
  subnet_group_name    = aws_elasticache_subnet_group.default.name
}