output "lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.external-elb.dns_name
}

output "Application_Instance_IP" {
  value = aws_instance.privateinstance.private_ip
}

output "Bastion_Instance_IP" {
  value = aws_instance.publicinstance.public_ip
}

output "RDS_HOSTNAME" {
   value = aws_db_instance.iti-rds.endpoint
}

output "RDS_PORT" {
   value = aws_db_instance.iti-rds.port
}

output "REDIS_HOSTNAME" {
   value = aws_elasticache_cluster.example.cluster_address
}

output "REDIS_PORT" {
   value = aws_elasticache_cluster.example.port
}