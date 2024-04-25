variable "aws_region" {
  default = "us-east-1"
}
variable "ami_id" {
  default = "ami-0a3c3a20c09d6f377"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "subnet1_id" {
  default = "subnet-0f1e42859f3ad43c3"
}
variable "subnet2_id" {
  default = "subnet-0e0420f94c95acd22"
}
variable "security_group1_id" {
  default = "sg-06bc9cdd724e815b1"
}
variable "security_group2_id" {
  default = "sg-048baa2ebfebb7aae"
}
variable "instance1_name" {
  default = "PEPOC1"
}
variable "instance2_name" {
  default = "PEPOC2"
}
variable "my-key-pair" {
  default = "Balaji Mariyappan"
}
variable "vpc_id" {
  default = "vpc-b30658d4"
}
variable "AZ" {
  default = "us-east-1c"
}

