provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "example1" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id    = var.subnet1_id
  vpc_security_group_ids = [var.security_group1_id]
  key_name     = var.my-key-pair

  associate_public_ip_address = false

  tags = {
    Name = var.instance1_name
  }
}

#output "instance1_private_ip" {
#  value = aws_instance.example1.private_ip
#}