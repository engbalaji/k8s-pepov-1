# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "eks-pepoc"
  type        = string
    
}

variable "vpc_use" {
  type        = string
  description = "VPC to be used"
  default     = "vpc-b30658d4"
}

variable "eks_role_arn" {
  description = "EKS IAM Role ARN"
  type        = string
  default     = "arn:aws:iam::960456129040:role/SpaceLift_SSPOC_Role"
}

variable "sg_use" {
  description = "Security Group to be used"
  type        = string
  default     = "test_bm_sg_app"
}

variable "ec2_ssh_key" {
  description = "EC2 SSH Key"
  type        = string
  default     = "Balaji Mariyappan"
}

variable "max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 1
}