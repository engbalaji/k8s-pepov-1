# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
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

variable "ec2_ssh_key" {
  description = "EC2 SSH Key"
  type        = string
  default     = "Balaji Mariyappan"
}

variable "release_name" {
  type        = string
  description = "Helm release name"
  default     = "argocd"
}
variable "namespace" {
  description = "Namespace to install ArgoCD chart into"
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "Version of ArgoCD chart to install"
  type        = string
  default     = "5.27.1" # See https://artifacthub.io/packages/helm/argo/argo-cd for latest version(s)
}

# Helm chart deployment can sometimes take longer than the default 5 minutes
variable "timeout_seconds" {
  type        = number
  description = "Helm chart deployment can sometimes take longer than the default 5 minutes. Set a custom timeout here."
  default     = 800 # 10 minutes
}

variable "admin_password" {
  description = "Default Admin Password"
  type        = string
  default     = "Welcome#77"
}

variable "values_file" {
  description = "The name of the ArgoCD helm chart values file to use"
  type        = string
  default     = "values.yaml"
}

variable "enable_dex" {
  type        = bool
  description = "Enabled the dex server?"
  default     = true
}

variable "insecure" {
  type        = bool
  description = "Disable TLS on the ArogCD API Server?"
  default     = false
}

variable "vpc_use" {
  type        = string
  description = "VPC to be used"
  default     = "vpc-b30658d4"
}