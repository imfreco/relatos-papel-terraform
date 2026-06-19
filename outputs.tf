output "alb_dns_name" {
  description = "DNS name of the public Application Load Balancer."
  value       = module.load_balancer.alb_dns_name
}

output "frontend_url" {
  description = "Frontend URL served by the public Application Load Balancer."
  value       = "http://${module.load_balancer.alb_dns_name}"
}

output "backend_api_url" {
  description = "Backend API URL routed through the public Application Load Balancer."
  value       = "http://${module.load_balancer.alb_dns_name}/api"
}

output "rds_private_endpoint" {
  description = "Private endpoint of the RDS PostgreSQL instance."
  value       = module.database.rds_endpoint
}

output "vpc_id" {
  description = "ID of the VPC created for Relatos de Papel."
  value       = module.network.vpc_id
}

output "target_group_names" {
  description = "Names of the frontend and backend Target Groups."
  value       = module.load_balancer.target_group_names
}
