resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_db_subnet_ids

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-db-subnet-group"
  })
}
