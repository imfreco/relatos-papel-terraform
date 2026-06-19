resource "aws_autoscaling_group" "frontend" {
  name                = "${var.project_name}-frontend-asg"
  vpc_zone_identifier = var.private_app_subnet_ids
  desired_capacity    = var.frontend_desired_capacity
  min_size            = var.frontend_min_size
  max_size            = var.frontend_max_size

  health_check_type         = "ELB"
  health_check_grace_period = 300
  target_group_arns         = [var.frontend_target_group_arn]

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = local.frontend_asg_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "backend" {
  name                = "${var.project_name}-backend-asg"
  vpc_zone_identifier = var.private_app_subnet_ids
  desired_capacity    = var.backend_desired_capacity
  min_size            = var.backend_min_size
  max_size            = var.backend_max_size

  health_check_type         = "ELB"
  health_check_grace_period = 300
  target_group_arns         = [var.backend_target_group_arn]

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = local.backend_asg_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
