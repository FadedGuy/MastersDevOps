
output "app_instance_public_ip" {
  description = "IP publica de la instancia de la app"
  value       = module.compute.app_public_ip
}

output "app_instance_private_ip" {
  description = "IP privada de la instancia de la app"
  value       = module.compute.app_private_ip
}

output "mongodb_instance_public_ip" {
  description = "IP publica de la instancia de mongo"
  value       = module.compute.mongo_public_ip
}

output "mongodb_instance_private_ip" {
  description = "IP privada de la instancia de mongo"
  value       = module.compute.mongo_private_ip
}

output "alb_dns_name" {
  description = "DNS del balanceador"
  value       = module.load_balancer.alb_dns_name
}

output "nat_gateway_ip" {
  description = "IP publica del NAT"
  value       = module.network.nat_gateway_id
}
