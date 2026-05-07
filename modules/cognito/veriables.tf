# -------------------------------------------------
  # Input variables (feel free to extend)
  # -------------------------------------------------
  variable "aws_region" {
    description = "AWS region to deploy Cognito resources"
    type        = string
    default     = "us-east-1"
  }

  variable "user_pool_name" {
    description = "Name of the Cognito User Pool"
    type        = string
    default     = "example-user-pool"
  }

  variable "app_client_name" {
    description = "Name of the Cognito App Client"
    type        = string
    default     = "example-app-client"
  }