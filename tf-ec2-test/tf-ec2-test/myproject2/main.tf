provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "example1" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id    = var.subnet1_id
  vpc_security_group_ids = [var.security_group1_id]
  key_name     = var.my-key-pair

  tags = {
    Name = var.instance1_name
  }
}

resource "aws_instance" "example2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id    = var.subnet2_id
  vpc_security_group_ids = [var.security_group2_id]
  key_name     = var.my-key-pair

  tags = {
    Name = var.instance2_name
  }
}

# output.tf
output "instance1_public_ip" {
  value = aws_instance.example1.public_ip
}

output "instance2_public_ip" {
  value = aws_instance.example2.public_ip
}