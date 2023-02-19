terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 3.0.1"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

resource "docker_network" "docker_network" {
  name = "docker_network"
}

resource "docker_container" "prometheus" {
  image = "prom/prometheus"
  name  = "prometheus"
  ports {
    internal = 9090
    external = 9090
  }
  networks_advanced {
    name = "docker_network"
  }
}

resource "docker_container" "loki" {
  image = "grafana/loki"
  name  = "loki"
  ports {
    internal = 3100
    external = 3100
  }
  networks_advanced {
    name = "docker_network"
  }
}

resource "docker_container" "promtail" {
  image = "grafana/promtail"
  name  = "promtail"

  networks_advanced {
    name = "docker_network"
  }
}

resource "docker_volume" "grafana-config" {
  name = "grafana-config"
}

resource "docker_container" "grafana" {
  image = "grafana/grafana"
  name  = "grafana"
  ports {
    internal = 3000
    external = 3000
  }
  networks_advanced {
    name = "docker_network"
  }
  volumes {
    volume_name    = docker_volume.grafana-config.name
    container_path = "/var/lib/grafana"
  }
  volumes {
    host_path = "${path.cwd}/grafana-datasource.yml"
    container_path = "/etc/grafana/provisioning/datasources/automatic.yml"
  }
}