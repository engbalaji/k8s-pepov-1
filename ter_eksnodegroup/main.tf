

# Data sources for existing VPC, subnets, and security groups
data "aws_vpc" "existing_vpc" {
  id = var.vpc_use
}


data "aws_security_group" "existing_sg" {
  name = "test_bm_sg_app"
}

#create node group 1
resource "aws_eks_node_group" "example_nodes" {
  cluster_name    = var.cluster_name
  node_group_name = "peng-1"
  node_role_arn   = "arn:aws:iam::960456129040:role/bmeks1-NodeInstanceRole-1AM6MX3S587QX"
  subnet_ids = ["subnet-89eb03a4", "subnet-c496e7e9", "subnet-b64d14ff" ]
  capacity_type = "SPOT"
  
  
  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  remote_access {
    ec2_ssh_key = var.ec2_ssh_key
  }

  # Tag the nodes in the node group
  tags = {
    Name = "peng-1"
  }
}

#create node group 2
resource "aws_eks_node_group" "example_nodes_2" {
  cluster_name    = var.cluster_name
  node_group_name = "peng-2"
  node_role_arn   = "arn:aws:iam::960456129040:role/bmeks1-NodeInstanceRole-1AM6MX3S587QX"
  subnet_ids = ["subnet-89eb03a4", "subnet-c496e7e9", "subnet-b64d14ff" ]
  capacity_type = "SPOT"
  
  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  remote_access {
    ec2_ssh_key = var.ec2_ssh_key
  }

  # Tag the nodes in the node group
  tags = {
    Name = "peng-2"
  }
}

