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

module "loki" {
  source = "./loki"

  docker_network_name = var.docker_network_name

  depends_on = [
    docker_network.docker_network
  ]
}

module "grafana" {
  source = "./grafana"

  docker_network_name = var.docker_network_name

  depends_on = [
    docker_network.docker_network
  ]
}

resource "grafana_data_source" "prometheus" {
  type                = "prometheus"
  name                = "Prometheus"
  url                 = "http://${docker_container.prometheus.name}:${docker_container.prometheus.ports[0].external}"
  access_mode         = "proxy"
  is_default          = true
  basic_auth_enabled  = false
  basic_auth_username = ""

  depends_on = [
    module.grafana
  ]
}

resource "grafana_data_source" "loki" {
  type                = "loki"
  name                = "Loki"
  url                 = "http://${module.loki.loki_name}:${module.loki.loki_port}"
  access_mode         = "proxy"
  is_default          = false
  basic_auth_enabled  = false
  basic_auth_username = ""

  depends_on = [
    module.grafana,
  ]
}