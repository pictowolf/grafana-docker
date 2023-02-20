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