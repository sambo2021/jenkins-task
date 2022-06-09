resource "aws_instance" "privateinstance" {
  instance_type = "t2.micro"
  ami = var.ami # https://cloud-images.ubuntu.com/locator/ec2/ (Ubuntu)
  subnet_id = module.iti.network_private_subnet_1_id
  security_groups = [module.iti.network_private_security_group_id]
  #keypair created in the region an i downloaded the private 
  key_name = "TF_key"
  disable_api_termination = false
  ebs_optimized = false
  root_block_device {
    volume_size = "10"
  }
  tags = {
    "Name" = "NEW_PrivateMachine-1"
  }
}









