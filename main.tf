resource "docker_network" "docker_network" {
  name = var.docker_network_name
}

module "prometheus" {
  source = "./prometheus"

  docker_network_name = var.docker_network_name

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
  url                 = "http://${module.prometheus.prometheus_name}:${module.prometheus.prometheus_port}"
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