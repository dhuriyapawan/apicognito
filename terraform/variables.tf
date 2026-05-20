# ==========================================
# AWS Region
# ==========================================

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# ==========================================
# Environment
# ==========================================

variable "environment" {
  description = "Environment name"

  type    = string
  default = "dev"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "Environment must be dev, stage, or prod."
  }
}

# ==========================================
# VPC Configuration
# ==========================================

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)

  default = [
    "192.168.1.0/24",
    "192.168.2.0/24"
  ]
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type        = list(string)

  default = [
    "192.168.3.0/24",
    "192.168.4.0/24"
  ]
}

variable "availability_zones" {
  description = "Availability zones"

  type = list(string)

  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}

# ==========================================
# Database Configuration
# ==========================================

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "javaapp"
}

variable "db_username" {
  description = "Database master username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}

# ==========================================
# EC2 / ASG Configuration
# ==========================================

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "asg_min_size" {
  description = "Minimum size of Auto Scaling Group"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum size of Auto Scaling Group"
  type        = number
  default     = 6
}

variable "asg_desired_capacity" {
  description = "Desired capacity of Auto Scaling Group"
  type        = number
  default     = 2
}

# ==========================================
# Security
# ==========================================

variable "allowed_ssh_cidr_blocks" {
  description = "CIDR blocks allowed for SSH access"

  type = list(string)

  default = [
    "0.0.0.0/0"
  ]
}

# ==========================================
# Monitoring
# ==========================================

# variable "alert_email" {
#   description = "Email address for monitoring alerts"
#   type        = string

#   validation {
#     condition     = can(regex("^.+@.+\\..+$", var.alert_email))
#     error_message = "Please provide a valid email address."
#   }
# }