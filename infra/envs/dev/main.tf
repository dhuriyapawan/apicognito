module "app" {
  source = "../../modules/api"

  environment = var.environment
  domain_name = var.domain_name
}