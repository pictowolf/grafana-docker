output "loki_name" {
  value = "${docker_container.loki.name}"
}

output "loki_port" {
  value = "${docker_container.loki.ports[0].external}"
}