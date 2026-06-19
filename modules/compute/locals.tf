locals {
  frontend_asg_tags = merge(var.common_tags, {
    Name = "${var.project_name}-frontend"
  })

  backend_asg_tags = merge(var.common_tags, {
    Name = "${var.project_name}-backend"
  })
}
