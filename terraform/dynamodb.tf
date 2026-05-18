resource "aws_dynamodb_table" "violations" {
  name         = "${var.project_name}-violations"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}