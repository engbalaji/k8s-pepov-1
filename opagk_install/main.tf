provider "kubernetes" {
}

resource "kubernetes_namespace" "gatekeeper" {
  metadata {
    name = "gatekeeper-system"
  }
}

module "opa_gatekeeper" {
  source = "github.com/project-octal/terraform-kubernetes-opa-gatekeeper"
  namespace = kubernetes_namespace.gatekeeper.metadata[0].name
}
