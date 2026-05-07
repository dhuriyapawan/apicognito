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

