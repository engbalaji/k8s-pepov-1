provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.instance1_name
  }
}

resource "null_resource" "stop_instance" {
  depends_on = [aws_instance.example]

  provisioner "local-exec" {
    command = "aws ec2 stop-instances --instance-ids ${aws_instance.example.id}"
  }
}

