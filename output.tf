output "dns_publica" {
  value = "http://${aws_instance.Domino_instance.public_dns}"
}
output "IP_publica" {
  description = "Direccion IP publica de la Instancia EC2"
  value       = "http://${aws_instance.Domino_instance.public_ip}"
}
