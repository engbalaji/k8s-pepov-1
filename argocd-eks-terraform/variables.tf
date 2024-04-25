variable "region" {
  default = "us-east-1"
}

variable "eks-name" {
  type    = string
  default = "pepoc-eks-cluster"
}

variable "env" {
  default = "dev"
}
