resource "docker_network" "docker_network" {
  name = var.docker_network_name
}

resource "docker_container" "prometheus" {
  image = "prom/prometheus"
  name  = "prometheus"
  ports {
    internal = 9090
    external = 9090
  }
  networks_advanced {
    name = var.docker_network_name
  }

  depends_on = [
    docker_network.docker_network
  ]
}

resource "docker_container" "loki" {
  image = "grafana/loki"
  name  = "loki"
  ports {
    internal = 3100
    external = 3100
  }
  networks_advanced {
    name = var.docker_network_name
  }

  depends_on = [
    docker_network.docker_network
  ]
}

resource "docker_container" "promtail" {
  image = "grafana/promtail"
  name  = "promtail"

  networks_advanced {
    name = var.docker_network_name
  }

  depends_on = [
    docker_network.docker_network
  ]
}

module "grafana" {
  source = "./grafana"
  
  docker_network_name = var.docker_network_name

  loki_host = docker_container.loki.name
  loki_port = docker_container.loki.ports[0].external

  prometheus_host = docker_container.prometheus.name
  prometheus_port = docker_container.prometheus.ports[0].external

  depends_on = [
    docker_network.docker_network
  ]
}