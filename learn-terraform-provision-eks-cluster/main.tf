# eks-cluster.tf

# Data sources for existing VPC, subnets, and security groups
data "aws_vpc" "existing_vpc" {
  id = var.vpc_use
}

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
