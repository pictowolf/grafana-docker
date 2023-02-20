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
}