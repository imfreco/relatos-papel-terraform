variable "project_name" {
  description = "Project name used for compute resource names."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for frontend and backend launch templates."
  type        = string
}

variable "private_app_subnet_ids" {
  description = "Private application subnet IDs used by Auto Scaling Groups."
  type        = list(string)
}

variable "frontend_security_group_id" {
  description = "Security group ID attached to frontend instances."
  type        = string
}

variable "backend_security_group_id" {
  description = "Security group ID attached to backend instances."
  type        = string
}

variable "frontend_target_group_arn" {
  description = "Target group ARN attached to the frontend Auto Scaling Group."
  type        = string
}

variable "backend_target_group_arn" {
  description = "Target group ARN attached to the backend Auto Scaling Group."
  type        = string
}

variable "frontend_google_drive_file_id" {
  description = "Google Drive file ID for the frontend ZIP artifact."
  type        = string
}

variable "frontend_desired_capacity" {
  description = "Desired capacity for the frontend Auto Scaling Group."
  type        = number
}

variable "frontend_min_size" {
  description = "Minimum size for the frontend Auto Scaling Group."
  type        = number
}

variable "frontend_max_size" {
  description = "Maximum size for the frontend Auto Scaling Group."
  type        = number
}

variable "backend_desired_capacity" {
  description = "Desired capacity for the backend Auto Scaling Group."
  type        = number
}

variable "backend_min_size" {
  description = "Minimum size for the backend Auto Scaling Group."
  type        = number
}

variable "backend_max_size" {
  description = "Maximum size for the backend Auto Scaling Group."
  type        = number
}

variable "common_tags" {
  description = "Common tags applied to compute resources."
  type        = map(string)
}
