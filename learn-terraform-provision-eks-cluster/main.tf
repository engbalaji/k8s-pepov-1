# eks-cluster.tf

# Data sources for existing VPC, subnets, and security groups
data "aws_vpc" "existing_vpc" {
  id = var.vpc_use
}

#data "aws_subnet_ids" "existing_subnets" {
#  vpc_id = data.aws_vpc.existing_vpc.id
#  tags   = { Name = "your-subnet-tag" }
#  #subnet_ids = ["subnet-89eb03a4", "subnet-c496e7e9", "subnet-b64d14ff" ]
#}

data "aws_security_group" "existing_sg" {
  name = var.sg_use
}

# Create EKS cluster
resource "aws_eks_cluster" "my_cluster" {
  name     = var.cluster_name
  role_arn = var.eks_role_arn
  tags = {
    Name = var.cluster_name

  }

  vpc_config {
    #subnet_ids = data.aws_subnet_ids.existing_subnets.ids
    security_group_ids = [data.aws_security_group.existing_sg.id]
    subnet_ids = ["subnet-89eb03a4", "subnet-c496e7e9", "subnet-b64d14ff" ]
  }
}

#create node group 1
#resource "aws_eks_node_group" "example_nodes" {
#  cluster_name    = "pepoc-eks-cluster"
#  node_group_name = "peng-1"
#  node_role_arn   = "arn:aws:iam::960456129040:role/bmeks1-NodeInstanceRole-1AM6MX3S587QX"
#  subnet_ids = ["subnet-89eb03a4", "subnet-c496e7e9", "subnet-b64d14ff" ]
#  capacity_type = "SPOT"
  
  
#  scaling_config {
#    desired_size = 2
#    max_size     = 3
#    min_size     = 1

#  }

#  remote_access {
#    ec2_ssh_key = "Balaji Mariyappan"
#  }

  # Tag the nodes in the node group
#  tags = {
#    Name = "peng-1"
#  }
#}

#create node group 2
#resource "aws_eks_node_group" "example_nodes_2" {
#  cluster_name    = "pepoc-eks-cluster"
#  node_group_name = "peng-2"
#  node_role_arn   = "arn:aws:iam::960456129040:role/bmeks1-NodeInstanceRole-1AM6MX3S587QX"
#  subnet_ids = ["subnet-89eb03a4", "subnet-c496e7e9", "subnet-b64d14ff" ]
#  capacity_type = "SPOT"
#  
#  scaling_config {
#    desired_size = 1
#    max_size     = 2
#    min_size     = 1
#  }
#  remote_access {
#    ec2_ssh_key = "Balaji Mariyappan"
#  }
#
#  # Tag the nodes in the node group
#  tags = {
#    Name = "peng-2"
#  }
#}

