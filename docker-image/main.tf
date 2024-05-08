terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "2.23.1"
    }
  }
}

provider "docker" {
  host = "tcp://localhost:2375"
}

resource "docker_image" "example" {
  name         = "example:latest"
  keep_locally = false

  build {
    path = "./Dockerfile"
  }
  }
}