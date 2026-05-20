data "aws_secretsmanager_secret" "rds" {
  name = "prod/rds/mysql"
}

data "aws_secretsmanager_secret_version" "rds" {
  secret_id = data.aws_secretsmanager_secret.rds.id
}

locals {
  rds_secret = jsondecode(
    data.aws_secretsmanager_secret_version.rds.secret_string
  )
}