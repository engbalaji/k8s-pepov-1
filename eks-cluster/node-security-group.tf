resource "aws_security_group" "node-sg" {
  name        = "${local.cluster_name}-node-sg"
  description = "Allow all traffic to EKS nodes"
  vpc_id      = var.vpc_id
  tags = {
    Application       = "ODM"
    ApplicationRole   = "EKS node group security group"
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

resource "aws_vpc_security_group_egress_rule" "node-sg-egress" {
  security_group_id = aws_security_group.node-sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "node-sg-intracluster-ingress" {
  security_group_id            = aws_security_group.node-sg.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.node-sg.id
  description                  = "${var.security_group_revision_one_change_number} - Intracluster traffic"
}

resource "aws_vpc_security_group_ingress_rule" "node-cluster-rpc-ingress" {
  security_group_id            = aws_security_group.node-sg.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.cluster-sg.id
  description                  = "${var.security_group_revision_one_change_number} - Allow all traffic from cluster"
}
