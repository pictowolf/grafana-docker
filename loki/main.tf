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
}

resource "docker_container" "promtail" {
  image = "grafana/promtail"
  name  = "promtail"

  networks_advanced {
    name = var.docker_network_name
  }
}