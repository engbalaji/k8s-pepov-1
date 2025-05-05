resource "aws_iam_role" "eks-node-group-role" {
  name_prefix = "eks-node-group-role-"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
  tags = {
    Application       = "ODM"
    ApplicationRole   = "EKS Node Group IAM role"
    Brand             = "RCI"
    Creator           = "Terraform"
    Environment       = var.environment
    LOB               = "Panorama"
    Project           = "ODM Upgrade"
    OwnedBy           = "Qin Tang"
    OwnerGroup        = "RCI Web Middleware Support"
    ManagedBy         = "Scott Cromar"
    ManagedByGroup    = "WYND Cloud Services"
    SupportGroup      = "WynD Middleware Managed Svcs"
    CostCenter        = "1959"
    KubernetesVersion = var.kubernetes_version
  }
}

resource "aws_iam_instance_profile" "eks-node-group-instance-profile" {
  name_prefix = "eks-node-group-instance-profile-"
  role        = aws_iam_role.eks-node-group-role.name
}

resource "aws_iam_role_policy_attachment" "eks-node-group-policy-attachment" {
  role       = aws_iam_role.eks-node-group-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks-node-group-cni-policy-attachment" {
  role       = aws_iam_role.eks-node-group-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks-node-group-ec2-policy-attachment" {
  role       = aws_iam_role.eks-node-group-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks-node-group-ssm-policy-attachment" {
  role       = aws_iam_role.eks-node-group-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "eks-node-group-cloudwatch-agent-server-policy-attachment" {
  role       = aws_iam_role.eks-node-group-role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_launch_template" "eks-node-group-launch-template" {
  name_prefix            = "${local.cluster_name}-ng"
  image_id               = var.ami_id
  vpc_security_group_ids = [aws_security_group.node-sg.id]
  lifecycle {
    create_before_destroy = true
  }
  metadata_options {
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    http_endpoint               = "enabled"
  }
  tags = {
    Name = "eks-node-group"
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Application         = "ODM"
      ApplicationRole     = "EKS Managed Node"
      Brand               = "RCI"
      Creator             = "EKS"
      Environment         = var.environment
      LOB                 = "Panorama"
      Name                = "${var.environment} EKS Host - Amazon Linux 2023"
      OS                  = "Amazon Linux 2023"
      Project             = "ODM Upgrade"
      OwnedBy             = "Qin Tang"
      OwnerGroup          = "RCI Web Middleware Support"
      ManagedBy           = "Scott Cromar"
      ManagedByGroup      = "WYND Cloud Services"
      SupportGroup        = "WynD Middleware Managed Svcs"
      PCI                 = "CAT 2"
      SOX                 = "No"
      BusinessCriticality = "Tier 3"
      Backup              = "NoBackup"
      AlarmDisable        = "allalarms"
      CostCenter          = "1959"
      DomainMember        = "None"
      KubernetesVersion   = var.kubernetes_version
      EKSClusterName      = local.cluster_name
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Application         = "ODM"
      ApplicationRole     = "EKS Managed Node"
      Brand               = "RCI"
      Creator             = "EKS"
      Environment         = var.environment
      LOB                 = "Panorama"
      Name                = "${var.environment} EKS Host - Amazon Linux 2023"
      OS                  = "Amazon Linux 2023"
      Project             = "ODM Upgrade"
      OwnedBy             = "Qin Tang"
      OwnerGroup          = "RCI Web Middleware Support"
      ManagedBy           = "Scott Cromar"
      ManagedByGroup      = "WYND Cloud Services"
      SupportGroup        = "WynD Middleware Managed Svcs"
      PCI                 = "CAT 2"
      SOX                 = "No"
      BusinessCriticality = "Tier 3"
      Backup              = "NoBackup"
      AlarmDisable        = "allalarms"
      CostCenter          = "1959"
      DomainMember        = "None"
      KubernetesVersion   = var.kubernetes_version
      EKSClusterName      = local.cluster_name
    }
  }

  tag_specifications {
    resource_type = "network-interface"
    tags = {
      Application         = "ODM"
      ApplicationRole     = "EKS Managed Node"
      Brand               = "RCI"
      Creator             = "EKS"
      Environment         = var.environment
      LOB                 = "Panorama"
      Name                = "${var.environment} EKS Host - Amazon Linux 2023"
      OS                  = "Amazon Linux 2023"
      Project             = "ODM Upgrade"
      OwnedBy             = "Qin Tang"
      OwnerGroup          = "RCI Web Middleware Support"
      ManagedBy           = "Scott Cromar"
      ManagedByGroup      = "WYND Cloud Services"
      SupportGroup        = "WynD Middleware Managed Svcs"
      PCI                 = "CAT 2"
      SOX                 = "No"
      BusinessCriticality = "Tier 3"
      Backup              = "NoBackup"
      AlarmDisable        = "allalarms"
      CostCenter          = "1959"
      DomainMember        = "None"
      KubernetesVersion   = var.kubernetes_version
      EKSClusterName      = local.cluster_name
    }
  }
  user_data = base64encode(templatefile("${path.module}/templates/userdata.tpl", {
    cluster_name     = local.cluster_name
    cluster_cidr     = var.cluster_cidr
    cluster_endpoint = aws_eks_cluster.eks-cluster.endpoint
    cluster_ca       = aws_eks_cluster.eks-cluster.certificate_authority[0].data
  }))
}

resource "aws_eks_node_group" "eks-node-group" {
  ami_type               = "CUSTOM"
  cluster_name           = aws_eks_cluster.eks-cluster.name
  node_group_name_prefix = "${local.cluster_name}-ng"
  node_role_arn          = aws_iam_role.eks-node-group-role.arn
  instance_types         = var.instance_types
  subnet_ids = [
    var.subnet_id_a,
    var.subnet_id_b
  ]
  scaling_config {
    desired_size = 3
    min_size     = var.cluster_min_capacity
    max_size     = var.cluster_max_capacity
  }
  launch_template {
    id      = aws_launch_template.eks-node-group-launch-template.id
    version = "$Latest"
  }
  update_config {
    max_unavailable = 1
  }
  depends_on = [aws_eks_cluster.eks-cluster]
  lifecycle {
    ignore_changes        = [scaling_config[0].desired_size]
    create_before_destroy = true
  }

  tags = {
    Application         = "ODM"
    ApplicationRole     = "EKS Node Group"
    Brand               = "RCI"
    Creator             = "EKS"
    Environment         = var.environment
    LOB                 = "Panorama"
    OS                  = "Amazon Linux 2023"
    Project             = "ODM Upgrade"
    OwnedBy             = "Qin Tang"
    OwnerGroup          = "RCI Web Middleware Support"
    ManagedBy           = "Scott Cromar"
    ManagedByGroup      = "WYND Cloud Services"
    SupportGroup        = "WynD Middleware Managed Svcs"
    PCI                 = "CAT 2"
    SOX                 = "No"
    BusinessCriticality = "Tier 3"
    CostCenter          = "1959"
    KubernetesVersion   = var.kubernetes_version
  }
}
