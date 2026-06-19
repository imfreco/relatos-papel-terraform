output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.main.id
}

output "public_alb_subnet_ids" {
  description = "Public subnet IDs used by the Application Load Balancer."
  value       = [for az_key in local.az_keys : aws_subnet.public_alb[az_key].id]
}

output "private_app_subnet_ids" {
  description = "Private application subnet IDs used by EC2 Auto Scaling Groups."
  value       = [for az_key in local.az_keys : aws_subnet.private_app[az_key].id]
}

output "private_db_subnet_ids" {
  description = "Private database subnet IDs used by RDS."
  value       = [for az_key in local.az_keys : aws_subnet.private_db[az_key].id]
}
