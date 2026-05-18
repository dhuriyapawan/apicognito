output "lambda_name" {
  value = aws_lambda_function.violation_handler.function_name
}

output "sns_topic" {
  value = aws_sns_topic.alerts.arn
}