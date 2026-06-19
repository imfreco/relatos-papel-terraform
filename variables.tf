variable "aws_region" {
  description = "AWS region where the infrastructure will be created."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource names and tags."
  type        = string
  default     = "relatos-papel"

  validation {
    condition = (
      can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?$", var.project_name)) &&
      length(var.project_name) <= 26 &&
      !can(regex("--", var.project_name)) &&
      !can(regex("^sg-", var.project_name)) &&
      !can(regex("^internal-", var.project_name))
    )
    error_message = "project_name must use lowercase letters, numbers, and hyphens; start and end with an alphanumeric character; be 26 characters or less; and must not start with sg- or internal-."
  }
}

variable "environment" {
  description = "Environment name used for tags."
  type        = string
  default     = "academy"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "az_a" {
  description = "First availability zone."
  type        = string
  default     = "us-east-1a"
}

variable "az_b" {
  description = "Second availability zone."
  type        = string
  default     = "us-east-1b"
}

variable "instance_type" {
  description = "EC2 instance type for frontend and backend launch templates."
  type        = string
  default     = "t3.micro"
}

variable "frontend_google_drive_file_id" {
  description = "Google Drive file ID for the frontend ZIP artifact."
  type        = string
  default     = "1_aRS_6cYOqO-5hUUHoSMhmKY047v4idi"
}

variable "frontend_desired_capacity" {
  description = "Desired capacity for the frontend Auto Scaling Group."
  type        = number
  default     = 2
}

variable "frontend_min_size" {
  description = "Minimum size for the frontend Auto Scaling Group."
  type        = number
  default     = 2
}

variable "frontend_max_size" {
  description = "Maximum size for the frontend Auto Scaling Group."
  type        = number
  default     = 4
}

variable "backend_desired_capacity" {
  description = "Desired capacity for the backend Auto Scaling Group."
  type        = number
  default     = 2
}

variable "backend_min_size" {
  description = "Minimum size for the backend Auto Scaling Group."
  type        = number
  default     = 2
}

variable "backend_max_size" {
  description = "Maximum size for the backend Auto Scaling Group."
  type        = number
  default     = 4
}

variable "db_name" {
  description = "Initial PostgreSQL database name."
  type        = string
  default     = "relatosdb"

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9_]{0,62}$", var.db_name))
    error_message = "db_name must start with a letter and contain only letters, numbers, and underscores, with a maximum length of 63 characters."
  }
}

variable "db_username" {
  description = "PostgreSQL master username."
  type        = string
  default     = "postgres"

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9]{0,62}$", var.db_username))
    error_message = "db_username must start with a letter and contain only letters and numbers, with a maximum length of 63 characters."
  }
}

variable "db_password" {
  description = "PostgreSQL master password. Provide it through terraform.tfvars, environment variables, or a secure secret workflow."
  type        = string
  sensitive   = true

  validation {
    condition = (
      length(var.db_password) >= 8 &&
      length(var.db_password) <= 128 &&
      !can(regex("[/@\" ]", var.db_password))
    )
    error_message = "db_password must be 8 to 128 characters and must not contain /, @, double quotes, or spaces."
  }
}

variable "db_instance_class" {
  description = "RDS PostgreSQL instance class."
  type        = string
  default     = "db.t3.micro"
}
