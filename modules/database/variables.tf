variable "project_name" {
  description = "Project name used for database resource names."
  type        = string
}

variable "private_db_subnet_ids" {
  description = "Private database subnet IDs used by RDS."
  type        = list(string)
}

variable "rds_security_group_id" {
  description = "Security group ID attached to RDS PostgreSQL."
  type        = string
}

variable "db_name" {
  description = "Initial PostgreSQL database name."
  type        = string
}

variable "db_username" {
  description = "PostgreSQL master username."
  type        = string
}

variable "db_password" {
  description = "PostgreSQL master password."
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS PostgreSQL instance class."
  type        = string
}

variable "common_tags" {
  description = "Common tags applied to database resources."
  type        = map(string)
}
