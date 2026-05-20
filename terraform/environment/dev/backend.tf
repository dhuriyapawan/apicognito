terraform {
  backend "s3" {
    bucket         = "backend-s3-logs "
    key            = "dev/terraform.tfstate"
    region         =  var.aws_region
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}