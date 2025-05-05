resource "aws_iam_policy" "eks-load-balancer-controller-policy" {
  name        = "odm-${var.environment}-load-balancer-controller-policy"
  description = "Policy for the EKS Load Balancer Controller"
  policy      = file("${path.module}/policies/eks-load-balancer-controller-policy.json")
  tags = {
    Application       = "ODM"
    ApplicationRole   = "EKS Cluster load balancer controller policy"
    Brand             = "RCI"
    Creator           = "EKS"
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

resource "aws_iam_role" "eks-cluster-role" {
  name_prefix = "odm-${var.environment}-eks-cluster-role-"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
  tags = {
    Application       = "ODM"
    ApplicationRole   = "EKS Cluster IAM role"
    Brand             = "RCI"
    Creator           = "EKS"
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

resource "aws_iam_role_policy_attachment" "eks-cluster-policy-attachment" {
  role       = aws_iam_role.eks-cluster-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-vpc-resource-controller-attachment" {
  role       = aws_iam_role.eks-cluster-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-compute-policy-attachment" {
  role       = aws_iam_role.eks-cluster-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSComputePolicy"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-block-storage-policy-attachment" {
  role       = aws_iam_role.eks-cluster-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSBlockStoragePolicy"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-load-balancing-policy-attachment" {
  role       = aws_iam_role.eks-cluster-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-networking-policy-attachment" {
  role       = aws_iam_role.eks-cluster-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSNetworkingPolicy"
}

resource "aws_kms_key" "eks-cluster-kms-key" {
  description             = "KMS key for EKS cluster"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  key_usage               = "ENCRYPT_DECRYPT"
  tags = {
    Application     = "ODM"
    ApplicationRole = "EKS secrets encryption key"
    Brand           = "RCI"
    Creator         = "EKS"
    Environment     = var.environment
    LOB             = "Panorama"
    Project         = "ODM Upgrade"
    OwnedBy         = "Qin Tang"
    OwnerGroup      = "RCI Web Middleware Support"
    ManagedBy       = "Scott Cromar"
    ManagedByGroup  = "WYND Cloud Services"
    SupportGroup    = "WynD Middleware Managed Svcs"
    CostCenter      = "1959"
  }
}

resource "aws_kms_alias" "eks-key-alias" {
  name_prefix   = "alias/${local.cluster_name}-eks-key"
  target_key_id = aws_kms_key.eks-cluster-kms-key.key_id
}

resource "aws_eks_cluster" "eks-cluster" {
  name                          = local.cluster_name
  role_arn                      = aws_iam_role.eks-cluster-role.arn
  bootstrap_self_managed_addons = true
  version                       = var.kubernetes_version
  upgrade_policy {
    support_type = "EXTENDED"
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {
    subnet_ids = [
      var.subnet_id_a,
      var.subnet_id_b,
    ]
    security_group_ids = [
      aws_security_group.cluster-sg.id,
    ]
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  # encryption_config {
  #   provider {
  #     key_arn = aws_kms_key.eks-cluster-kms-key.arn
  #   }
  #   resources = ["secrets"]
  # }

  kubernetes_network_config {
    service_ipv4_cidr = var.cluster_cidr
    ip_family         = "ipv4"
  }

  tags = {
    Application         = "ODM"
    ApplicationRole     = "EKS Cluster"
    Brand               = "RCI"
    Creator             = "EKS"
    Environment         = var.environment
    LOB                 = "Panorama"
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

resource "aws_eks_addon" "eks-vpc-cni-connector" {
  cluster_name = aws_eks_cluster.eks-cluster.name
  addon_name   = "vpc-cni"
  depends_on = [
    aws_iam_openid_connect_provider.eks-cluster-oidc-provider,
    aws_eks_cluster.eks-cluster,
    aws_eks_node_group.eks-node-group
  ]
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.eks-cluster.name
  addon_name   = "coredns"
  depends_on = [
    aws_eks_cluster.eks-cluster,
    aws_eks_node_group.eks-node-group
  ]
}

resource "aws_eks_addon" "eks-pod-identity-agent" {
  cluster_name = aws_eks_cluster.eks-cluster.name
  addon_name   = "eks-pod-identity-agent"
  depends_on = [
    aws_iam_openid_connect_provider.eks-cluster-oidc-provider,
    aws_eks_cluster.eks-cluster,
    aws_eks_node_group.eks-node-group
  ]
  configuration_values = file("${path.module}/config/pod-identity-agent-disable-ipv6.json")
}

resource "aws_eks_addon" "kube-proxy" {
  cluster_name = aws_eks_cluster.eks-cluster.name
  addon_name   = "kube-proxy"
  depends_on = [
    aws_eks_cluster.eks-cluster,
    aws_eks_node_group.eks-node-group
  ]
}

resource "aws_eks_access_entry" "cloud-services-access-entry" {
  cluster_name  = aws_eks_cluster.eks-cluster.name
  principal_arn = var.cloud_services_role_arn
  depends_on    = [aws_eks_addon.eks-pod-identity-agent]
}

resource "aws_eks_access_policy_association" "cloud-services-access-policy-association" {
  cluster_name  = aws_eks_cluster.eks-cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.cloud_services_role_arn
  access_scope {
    type = "cluster"
  }
  depends_on = [aws_eks_access_entry.cloud-services-access-entry]
}

resource "aws_eks_access_entry" "alternate-access-entry" {
  cluster_name  = aws_eks_cluster.eks-cluster.name
  principal_arn = var.alternate_role_arn
  depends_on    = [aws_eks_addon.eks-pod-identity-agent]
}

resource "aws_eks_access_policy_association" "alternate-access-policy-association" {
  cluster_name  = aws_eks_cluster.eks-cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = var.alternate_role_arn
  access_scope {
    type = "cluster"
  }
  depends_on = [aws_eks_access_entry.alternate-access-entry]
}

data "tls_certificate" "eks-cluster-ca" {
  url = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks-cluster-oidc-provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks-cluster-ca.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.eks-cluster-ca.url
}
