resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
}

resource "aws_apigatewayv2_domain_name" "api_domain" {
  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.cert.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

output "domain_target" {
  value = aws_apigatewayv2_domain_name.api_domain.domain_name_configuration[0].target_domain_name
}