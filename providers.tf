terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0.1"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "1.35.0"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

provider "grafana" {
  url  = "http://localhost:3000"
  auth = "admin:admin"
}