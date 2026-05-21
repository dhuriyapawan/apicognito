terraform {
  backend "s3" {
    bucket         = "backend-s3-logs"
    key            = "dev/terraform.tfstate"
    region         =  "us-east-1"
    dynamodb_table = "terraform-locks"
    
     encrypt        = true
  }
}
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "String"
  }
}