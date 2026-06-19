variable "project_name" {
  description = "Project name used for load balancer resource names."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where target groups will be created."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs used by the Application Load Balancer."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID attached to the Application Load Balancer."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to load balancer resources."
  type        = map(string)
}
