provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "example" {


  instance_id = var.instance_id
}

resource "aws_ec2_instance_state" "example" {
  instance_id = aws_instance.example.id
  state       = "stopped"
}

