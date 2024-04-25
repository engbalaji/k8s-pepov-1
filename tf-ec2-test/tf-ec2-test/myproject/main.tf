provider "aws" {
  region = "us-east-1"  # Change to your desired AWS region
}

resource "aws_instance" "example" {
  ami           = "ami-0df435f331839b2d6"  # Replace with your desired AMI
  instance_type = "t2.micro"              # Replace with your desired instance type

  subnet_id    = "subnet-89eb03a4"      # Replace with the subnet ID in your existing VPC
  vpc_security_group_ids = ["sg-02cd5c886d8b07682"]  # Replace with the security group IDs

  tags = {
    Name = "Instance_SS3"
  }
}