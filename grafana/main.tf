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
    name = var.docker_network_name
  }
  volumes {
    volume_name    = docker_volume.grafana-config.name
    container_path = "/var/lib/grafana"
  }
}

resource "grafana_data_source" "prometheus" {
  type                = "prometheus"
  name                = "Prometheus"
  url                 = "http://${var.prometheus_host}:${var.prometheus_port}"
  access_mode = "proxy"
  is_default = true
  basic_auth_enabled  = false
  basic_auth_username = ""

  depends_on = [
    docker_container.grafana
  ]
}

resource "grafana_data_source" "loki" {
  type                = "loki"
  name                = "Loki"
  url                 = "http://${var.loki_host}:${var.loki_port}"
  access_mode = "proxy"
  is_default = false
  basic_auth_enabled  = false
  basic_auth_username = ""

  depends_on = [
    docker_container.grafana
  ]
}