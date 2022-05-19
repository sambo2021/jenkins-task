#creating elastic ip to attach to nat getway 
resource "aws_eip" "elastic-ip" {
  vpc = true

}