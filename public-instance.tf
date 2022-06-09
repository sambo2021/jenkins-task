resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits = 4096
}
resource "aws_key_pair" "TF_key" {
  key_name = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh

    provisioner "local-exec" { 
    # Create "TF_key.pem" to your computer!!
    command = "echo '${tls_private_key.rsa.private_key_pem}' > ~/.ssh/TF_key.pem"
  }
}
# resource "local_file" "TF_key" {
#   content = tls_private_key.rsa.private_key_pem
#   filename = "TF_key.pem"
# }
resource "aws_instance" "publicinstance" {
  instance_type = "t2.micro"
  ami = var.ami # https://cloud-images.ubuntu.com/locator/ec2/ (Ubuntu)
  subnet_id = module.iti.network_public_subnet_1_id
  security_groups = [module.iti.network_public_security_group_id]
  #keypair created in the region an i downloaded the private 
  key_name = "TF_key"
  disable_api_termination = false
  ebs_optimized = false
  root_block_device {
    volume_size = "10"
  }
  tags = {
    "Name" = "NEW_MachineHoiston"
  }

   # printing out instance ip address on terminal 
   # this command mainly used to run scripts not just echo 
  provisioner "local-exec" {
    command = "echo the server IP address is ${self.public_ip}"
  }

}






