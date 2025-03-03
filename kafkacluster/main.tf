provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "kafka" {
  name       = "kafka"
  namespace  = "default"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "kafka"
  version    = "15.2.3"  # Use the latest version available

  set {
    name  = "replicaCount"
    value = "3"
  }

  set {
    name  = "zookeeper.replicaCount"
    value = "3"
  }

  # Example of setting resource requests and limits (customize as needed)
  set {
    name  = "resources.requests.cpu"
    value = "500m"
  }

  set {
    name  = "resources.requests.memory"
    value = "512Mi"
  }

  set {
    name  = "resources.limits.cpu"
    value = "1"
  }

  set {
    name  = "resources.limits.memory"
    value = "1Gi"
  }

  # Optionally, configure persistence
  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.size"
    value = "10Gi"
  }
}
