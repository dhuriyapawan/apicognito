variable "vpc_id" {
  type        = string
  description = "VPC ID where SGs will be created"
}

variable "environment" {
  type        = string
  description = "Environment name (dev/stage/prod)"
}

variable "ssh_allowed_cidrs" {
  type        = list(string)
  description = "CIDRs allowed for SSH access"
  default     = []
}