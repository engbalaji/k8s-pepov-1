resource "aws_security_group" "cluster-sg" {
  name        = "${local.cluster_name}-cluster-sg"
  description = "Allow all traffic to EKS cluster"
  vpc_id      = var.vpc_id
  tags = {
    Application       = "ODM"
    ApplicationRole   = "EKS cluster security group"
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

resource "aws_vpc_security_group_egress_rule" "cluster-sg-egress" {
  security_group_id = aws_security_group.cluster-sg.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "cluster-sg-intracluster-ingress" {
  security_group_id            = aws_security_group.cluster-sg.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.cluster-sg.id
  description                  = "${var.security_group_revision_one_change_number} - Intracluster traffic"
}

resource "aws_vpc_security_group_ingress_rule" "cluster-node-sg-ingress" {
  security_group_id            = aws_security_group.cluster-sg.id
  ip_protocol                  = "-1"
  referenced_security_group_id = aws_security_group.node-sg.id
  description                  = "${var.security_group_revision_one_change_number} - Allow all traffic from nodes"
}
resource "aws_vpc_security_group_ingress_rule" "cluster-management-ingress" {
  security_group_id = aws_security_group.cluster-sg.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = var.management_network_cidr
  description       = "${var.security_group_revision_one_change_number} - Allow administrative management traffic"
}

resource "aws_vpc_security_group_ingress_rule" "jenkins-k8s-ingress" {
  security_group_id = aws_security_group.cluster-sg.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "${var.jenkins_ip}/32"
  description       = "${var.security_group_revision_one_change_number} - Allow management traffic from Jenkins"
}
