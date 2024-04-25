
variable "access_key" {
  default = ""
}

variable "secret_key" {
  default = ""
}

variable "region" {
  default = "ap-south-1"
}

variable "amis" {
  type = "map"
  default = {
    ap-south-1 = "ami-f9daac96"
    us-east-1 = "ami-13be557e"
    us-west-2 = "ami-06b94666"
  }
}
