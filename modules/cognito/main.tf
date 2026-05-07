resource "aws_cognito_user_pool" "pool" {
  name = var.user_pool_name
}

resource "aws_cognito_user_pool_client" "client" {
  name         = "app-client"
  user_pool_id = aws_cognito_user_pool.pool.id

  explicit_auth_flows = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
}

output "user_pool_arn" {
  value = aws_cognito_user_pool.pool.arn
}