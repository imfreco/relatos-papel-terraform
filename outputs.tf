output "alb_dns_name" {
  description = "DNS name of the public Application Load Balancer."
  value       = aws_lb.main.dns_name
}

output "frontend_url" {
  description = "Frontend URL served by the public Application Load Balancer."
  value       = "http://${aws_lb.main.dns_name}"
}

output "backend_api_url" {
  description = "Backend API URL routed through the public Application Load Balancer."
  value       = "http://${aws_lb.main.dns_name}/api"
}

output "rds_private_endpoint" {
  description = "Private endpoint of the RDS PostgreSQL instance."
  value       = aws_db_instance.postgres.endpoint
}

output "vpc_id" {
  description = "ID of the VPC created for Relatos de Papel."
  value       = aws_vpc.main.id
}

output "target_group_names" {
  description = "Names of the frontend and backend Target Groups."
  value = {
    frontend = aws_lb_target_group.frontend.name
    backend  = aws_lb_target_group.backend.name
  }
}
