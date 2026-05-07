module "apigateway" {
  source = "../../modules/apigateway"

  environment = var.environment
  domain_name = var.domain_name
}