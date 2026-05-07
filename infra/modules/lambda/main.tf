resource "aws_lambda_function" "this" {
  function_name = "${var.name}-${var.environment}"
  role          = var.role_arn
  handler       = var.handler
  runtime       = var.runtime
  filename      = var.filename

  publish = true
}

resource "aws_lambda_alias" "live" {
  name             = "live"
  function_name    = aws_lambda_function.this.function_name
  function_version = aws_lambda_function.this.version
}

# Optional weighted routing for blue/green
resource "aws_lambda_alias" "canary" {
  name             = "canary"
  function_name    = aws_lambda_function.this.function_name
  function_version = aws_lambda_function.this.version

  routing_config {
    additional_version_weights = {
      "1" = 0.1
    }
  }
}