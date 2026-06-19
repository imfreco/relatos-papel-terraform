output "frontend_autoscaling_group_name" {
  description = "Name of the frontend Auto Scaling Group."
  value       = aws_autoscaling_group.frontend.name
}

output "backend_autoscaling_group_name" {
  description = "Name of the backend Auto Scaling Group."
  value       = aws_autoscaling_group.backend.name
}
