terraform {
  backend "s3" {
    bucket         = "api-cognito"
    key            = "infra.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
  }
}