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

resource "aws_ebs_volume" "example_ebs_volume" {
  availability_zone = var.availability_zone
  size              = var.volume_size # Specify the size of the volume in GiBs
  encrypted         = var.encrypted # Specify whether the volume should be encrypted

  tags = {
    Name = "ExampleEBSVolume"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh" # The device name may vary based on the instance type
  volume_id   = aws_ebs_volume.example_ebs_volume.id
  instance_id = aws_instance.example1.id
}
