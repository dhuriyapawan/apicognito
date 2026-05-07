module "users_service" {
  source = "../lambda"

  name        = "users"
  environment = var.environment
}

module "orders_service" {
  source = "../lambda"

  name        = "orders"
  environment = var.environment
}

resource "aws_apigatewayv2_api" "main" {
  name          = "main-api-${var.environment}"
  protocol_type = "HTTP"
}

# Example route
resource "aws_apigatewayv2_route" "users" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /users"

  target = "integrations/${aws_apigatewayv2_integration.users.id}"
}