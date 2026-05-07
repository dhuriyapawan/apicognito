provider "aws" {
  region = var.aws_region
}

# DynamoDB
module "dynamodb" {
  source = "infra/modules/dynamodb"

  table_name = "app-table"
}

# Cognito
module "cognito" {
  source = "infra/modules/cognito"

  user_pool_name = "app-user-pool"
}

# Lambda Layer
resource "aws_lambda_layer_version" "common_layer" {
  filename   = "layer.zip"
  layer_name = "common-layer"

  compatible_runtimes = ["nodejs18.x"]
}

# Lambda Function
module "lambda" {
  source = "infra/modules/lambda"

  function_name = "app-function"
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  layer_arn = aws_lambda_layer_version.common_layer.arn

  environment_variables = {
    TABLE_NAME = module.dynamodb.table_name
  }
}

# API Gateway
module "apigateway" {
  source = "infra/modules/apigateway"

  lambda_invoke_arn = module.lambda.invoke_arn
  user_pool_arn     = module.cognito.user_pool_arn
}