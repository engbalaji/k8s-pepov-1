# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_use" {
  type        = string
  description = "VPC to be used"
  default     = "vpc-b30658d4"
}

variable "cluster_name" {
  description = "Cluster name"
  type        = string
  default     = "eks-pepoc"
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

variable "eks_version" {
  description = "EKS version"
  type        = string
  default     = "1.30"
}

variable "ec2_ssh_key" {
  description = "EC2 SSH Key"
  type        = string
  default     = "Balaji Mariyappan"
}

