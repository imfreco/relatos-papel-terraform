resource "aws_lb_target_group" "service" {
  for_each = local.target_groups

  name        = "${var.project_name}-${each.value.name_suffix}"
  port        = each.value.port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200-399"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${each.value.name_suffix}"
  })
}
