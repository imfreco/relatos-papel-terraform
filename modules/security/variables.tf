variable "project_name" {
  description = "Project name used for security group names."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where security groups will be created."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to all security groups."
  type        = map(string)
}
