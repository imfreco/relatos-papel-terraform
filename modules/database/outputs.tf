output "rds_endpoint" {
  description = "Private endpoint of the RDS PostgreSQL instance."
  value       = aws_db_instance.postgres.endpoint
}
