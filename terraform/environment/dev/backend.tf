terraform {
  backend "s3" {
    bucket         = "backend-s3-logs"
    key            = "dev/terraform.tfstate"
    region         =  "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}