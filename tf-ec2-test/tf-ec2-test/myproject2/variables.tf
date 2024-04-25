variable "aws_region" {
  default = "us-east-1"
}
variable "ami_id" {
  default = "ami-0df435f331839b2d6"
}
variable "instance_type" {
  default = "t2.xlarge"
}
variable "subnet1_id" {
  default = "subnet-89eb03a4"
}
variable "subnet2_id" {
  default = "subnet-b64d14ff"
}
variable "security_group1_id" {
  default = "sg-02cd5c886d8b07682"
}
variable "security_group2_id" {
  default = "sg-02cd5c886d8b07682"
}
variable "instance1_name" {
  default = "sspoc1"
}
variable "instance2_name" {
  default = "sspoc2"
}
variable "my-key-pair" {
  default = "Balaji Mariyappan"
}