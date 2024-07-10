variable "aws_region" {
  default = "us-east-1"
}
variable "ami_id" {
  default = "ami-089d9f6c91edad62b"
}
variable "instance_type" {
  default = "t2.micro"
}
variable "subnet1_id" {
  default = "subnet-89eb03a4"
}
variable "security_group1_id" {
  default = "sg-02cd5c886d8b07682"
}
variable "instance1_name" {
  default = "sspoc1"
}
variable "my-key-pair" {
  default = "Balaji Mariyappan"
}

variable "availability_zone" {
  description = "The availability zone to launch the EBS volume in"
  type        = string
  default     = "us-east-1a"
}

variable "volume_size" {
  description = "The size of the EBS volume in GiBs"
  type        = number 
  default     = 33
  }
  
  variable "encrypted" {
    description = "Flag to indicate if the EBS volume should be encrypted"
    type        = bool
    default     = true
  }
  