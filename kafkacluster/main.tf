provider "kubernetes" {
  config_path = "/home/ec2-user/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "/home/ec2-user/.kube/config"
  }
}

resource "helm_release" "strimzi-kafka" {
  name       = "strimzi-kafka"
  namespace  = "default"
  repository = "https://strimzi.io/charts/"
  chart      = "strimzi-kafka-operator"
  version    = "0.30.0"  # Use a version from the search results
  // additional configuration...

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
