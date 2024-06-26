provider "aws" {
  region = var.region
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd-${var.env}"
  }
}

resource "helm_release" "argocd-staging" {
  name       = "argocd-staging"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "5.27.3"
  namespace  = "argocd-staging"
  timeout    = "1200"
  values     = [templatefile("./argocd/install.yaml", {})]
}

resource "null_resource" "password" {
  provisioner "local-exec" {
    working_dir = "./argocd"
    command     = "kubectl -n argocd-staging get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d > argocd-login.txt"
  }
}

resource "null_resource" "del-argo-pass" {
  depends_on = [null_resource.password]
  provisioner "local-exec" {
    command = "kubectl -n argocd-staging delete secret argocd-initial-admin-secret"
  }
}

}