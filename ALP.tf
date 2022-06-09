resource "aws_lb" "external-elb" {
  name               = "External-LB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.iti.network_public_security_group_id]
  subnets            = [module.iti.network_public_subnet_1_id, module.iti.network_public_subnet_2_id]
}

resource "aws_lb_target_group" "external-elb" {
  name     = "ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.iti.network_vpc_id
}

resource "aws_lb_target_group_attachment" "external-elb1" {
  target_group_arn = aws_lb_target_group.external-elb.arn
  target_id        = aws_instance.privateinstance.id
  port             = 80

  depends_on = [
    aws_instance.privateinstance,
  ]
}


resource "aws_lb_listener" "external-elb" {
  load_balancer_arn = aws_lb.external-elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external-elb.arn
  }
}

# output "lb_dns_name" {
#   description = "The DNS name of the load balancer"
#   value       = aws_lb.external-elb.dns_name
# }