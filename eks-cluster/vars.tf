variable "vpc_id" {
  description = "The VPC ID"
  nullable    = false
  type        = string
}

variable "subnet_id_a" {
  description = "The subnet ID for the first subnet"
  nullable    = false
  type        = string
}

variable "subnet_id_b" {
  description = "The subnet ID for the second subnet"
  nullable    = false
  type        = string
}

variable "environment" {
  description = "The environment for the cluster"
  nullable    = false
  type        = string
  default     = "lab"
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the cluster"
  nullable    = false
  type        = string
  default     = "1.30"
}

variable "cloud_services_role_arn" {
  description = "The ARN of the role to be used by cloud services"
  nullable    = false
  type        = string
  default     = "arn:aws:iam::960456129040:role/aws-reserved/sso.amazonaws.com/us-west-2/AWSReservedSSO_AWSAdministratorAccess_6761273c3babe23a"
}

variable "alternate_role_arn" {
  description = "The ARN of the role to be used by cloud services"
  nullable    = false
  type        = string
  default     = "arn:aws:iam::960456129040:role/DerikKMSAdministratorTestRole"
}

variable "ami_id" {
  description = "The AMI ID for the node group"
  nullable    = false
  type        = string
}

variable "min_node_cpu_count" {
  description = "The minimum number of CPUs for the node group"
  nullable    = false
  type        = number
  default     = 2
}

variable "max_node_cpu_count" {
  description = "The maximum number of CPUs for the node group"
  nullable    = false
  type        = number
  default     = 4
}

variable "min_node_mem_GiB" {
  description = "The minimum amount of memory in GiB for the node group"
  nullable    = false
  type        = number
  default     = 2
}

variable "max_node_mem_GiB" {
  description = "The maximum amount of memory in GiB for the node group"
  nullable    = false
  type        = number
  default     = 16
}

variable "cluster_min_capacity" {
  description = "The minimum number of nodes in the node group"
  nullable    = false
  type        = number
  default     = 3
}

variable "cluster_max_capacity" {
  description = "The maximum number of nodes in the node group"
  nullable    = false
  type        = number
  default     = 6
}

variable "aws_region" {
  description = "The AWS region to deploy to"
  nullable    = false
  type        = string
  default     = "us-east-1"
}

variable "cluster_cidr" {
  description = "The CIDR block for the cluster"
  nullable    = false
  type        = string
  default     = "172.20.0.0/16"
}

variable "jenkins_ip" {
  description = "The IP address of the Jenkins server"
  nullable    = false
  type        = string
}

variable "instance_types" {
  description = "The instance types for the node group"
  nullable    = false
  type        = list(string)
}

variable "management_network_cidr" {
  description = "The CIDR block for the management network"
  nullable    = false
  type        = string
}

variable "security_group_revision_one_change_number" {
  description = "The change number for the first revision of the security group"
  nullable    = false
  type        = string
}

locals {
  cluster_name = "eks-odm-${var.environment}-cluster"
} 
