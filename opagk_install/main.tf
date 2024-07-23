provider "kubernetes" {
 # host                   = var.k8s_host
 # token                  = var.k8s_token
  cluster_ca_certificate = base64decode(var.k8s_ca_certificate)
}

resource "kubernetes_namespace" "gatekeeper" {
  metadata {
	name = "gatekeeper-system"
  }
}

module "opa_gatekeeper" {
  source    = "git::https://github.com/project-octal/terraform-kubernetes-opa-gatekeeper"
  namespace = kubernetes_namespace.gatekeeper.metadata[0].name
    version   = "0.1.0"
    cluster_ca_certificate = base64decode(var.k8s_ca_certificate)
}
