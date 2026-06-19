variable "project_name" {
  description = "Project name used for network resource names."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "az_a" {
  description = "First availability zone."
  type        = string
}

variable "az_b" {
  description = "Second availability zone."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to all network resources."
  type        = map(string)
}
