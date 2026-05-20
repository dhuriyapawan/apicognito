module "vpc" {
  source = "./modules/vpc"

  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}
module "iam" {
  source = "./modules/iam"

  environment    = var.environment
  aws_account_id = var.aws_account_id
  github_repo    = var.github_repo
}
module "security_groups" {
  source = "./modules/security_groups"

  vpc_id             = module.vpc.vpc_id
  environment        = var.environment
  ssh_allowed_cidrs = ["YOUR_PUBLIC_IP/32"]
}
module "rds" {
  source = "./modules/rds"

  name        = "app-db"
  environment = var.environment

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  secret_arn = module.db_secret.secret_arn
}
module "redis" {
  source = "../../modules/redis"

  name        = "app-redis"
  environment = var.environment

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  allowed_security_group_ids = [
    module.eks.node_security_group_id
  ]
}
module "ecr_app" {
  source = "../../modules/ecr"

  name        = "app-service"
  environment = var.environment
}
module "eks" {
  source = "../../modules/eks"

  cluster_name        = "app-eks"
  environment         = var.environment
  private_subnet_ids  = module.vpc.private_subnet_ids

  desired_size = 2
  max_size     = 4
  min_size     = 1
}