output "prometheus_name" {
  value = "${docker_container.prometheus.name}"
}

output "prometheus_port" {
  value = "${docker_container.prometheus.ports[0].external}"
}