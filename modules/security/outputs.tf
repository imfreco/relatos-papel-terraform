output "alb_security_group_id" {
  description = "Security group ID for the public Application Load Balancer."
  value       = aws_security_group.alb.id
}

output "frontend_security_group_id" {
  description = "Security group ID for frontend instances."
  value       = aws_security_group.frontend.id
}

output "backend_security_group_id" {
  description = "Security group ID for backend instances."
  value       = aws_security_group.backend.id
}

output "rds_security_group_id" {
  description = "Security group ID for RDS PostgreSQL."
  value       = aws_security_group.rds.id
}
