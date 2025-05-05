variable "aws_region" {
  default = "us-east-1"
}
variable "ami_id" {
  default = "ami-089d9f6c91edad62b"
}
variable "instance_type" {
  default = "t2.xlarge"
}
variable "subnet1_id" {
  default = "subnet-89eb03a4"
}

variable "security_group1_id" {
  default = "sg-02cd5c886d8b07682"
}

variable "instance1_name" {
  default = "po_worrier"
}

variable "my-key-pair" {
  default = "Balaji Mariyappan"
}