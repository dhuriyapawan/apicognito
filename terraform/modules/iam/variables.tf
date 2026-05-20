# modules/iam/variables.tf

variable "environment" {
  type = string
}

variable "aws_account_id" {
  type = string
  default = "878445923420"
}

variable "github_repo" {
  type = string
}