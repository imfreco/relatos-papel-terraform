output "alb_dns_name" {
  description = "DNS name of the public Application Load Balancer."
  value       = aws_lb.main.dns_name
}

output "frontend_target_group_arn" {
  description = "ARN of the frontend target group."
  value       = aws_lb_target_group.service["frontend"].arn
}

output "backend_target_group_arn" {
  description = "ARN of the backend target group."
  value       = aws_lb_target_group.service["backend"].arn
}

output "target_group_names" {
  description = "Names of the frontend and backend target groups."
  value = {
    frontend = aws_lb_target_group.service["frontend"].name
    backend  = aws_lb_target_group.service["backend"].name
  }
}
