provider "aws" {
  region = var.region
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd-${var.env}"
  }
}

resource "helm_release" "argocd-dev" {
  name       = "argocd-${var.env}"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "5.27.3"
  namespace  = "argocd-${var.env}"
  timeout    = "1200"
  #values = [yamlencode(file("./argocd/install.yaml"))]
  values = ["${file("argocd/install.yaml")}"]
}

resource "null_resource" "password" {
  provisioner "local-exec" {
    working_dir = "./argocd"
    command     = "./kubectl -n argocd-dev get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d > argocd-login.txt"
  }
}

resource "null_resource" "del-argo-pass" {
  depends_on = [null_resource.password]
  provisioner "local-exec" {
    command = "./kubectl -n argocd-dev delete secret argocd-initial-admin-secret"
  }
}
