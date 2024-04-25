provider "aws" {
    // Configure the AWS provider here
    region = var.aws_region
}

####################################
# VPC and subnets
####################################

####################################
# Create an AWS EC2 instance
####################################

resource "aws_instance" "web" {
    // Configure the AWS instance here
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.my-key-pair
    vpc_security_group_ids = [var.security_group1_id]
    subnet_id = var.subnet1_id
    tags = {
        Name = var.instance1_name
    }
}

####################################
# Create an EBS volume and attach it to the EC2 instance
####################################

resource "aws_ebs_volume" "ebs_volume" {
    // Configure the EBS volume here
    availability_zone = var.AZ
    size = 33
    encrypted = true
    type = "gp2"
    tags = {
        Name = "terraform-example"
    }
}

resource "aws_volume_attachment" "ebs_attachment" {
    // Configure the EBS volume attachment here
    instance_id = aws_instance.web.id
    volume_id = aws_ebs_volume.ebs_volume.id
    device_name = "/dev/sdh"
}

####################################
# Installing apache web server
####################################
#module "apache" {
#    source = "./modules/apache"
#
#    ec2_instance_id = module.ec2_instance.id
#}