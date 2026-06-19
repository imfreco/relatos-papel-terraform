resource "aws_launch_template" "frontend" {
  name_prefix   = "${var.project_name}-frontend-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.frontend_security_group_id]

  user_data = base64encode(templatefile("${path.module}/templates/user_data_frontend.sh", {
    google_drive_file_id = var.frontend_google_drive_file_id
  }))

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.common_tags, {
      Name = "${var.project_name}-frontend"
      Tier = "frontend"
    })
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(var.common_tags, {
      Name = "${var.project_name}-frontend-volume"
      Tier = "frontend"
    })
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-frontend-lt"
  })
}

resource "aws_launch_template" "backend" {
  name_prefix   = "${var.project_name}-backend-"
  image_id      = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.backend_security_group_id]

  user_data = base64encode(file("${path.module}/templates/user_data_backend.sh"))

  tag_specifications {
    resource_type = "instance"

    tags = merge(var.common_tags, {
      Name = "${var.project_name}-backend"
      Tier = "backend"
    })
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(var.common_tags, {
      Name = "${var.project_name}-backend-volume"
      Tier = "backend"
    })
  }

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-backend-lt"
  })
}
