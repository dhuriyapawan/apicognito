module "vpc" {
  source = "../../modules/vpc"

  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs = var.availability_zones
  availability_zones   = "us-east-1"
}

module "iam" {
  source = "../../modules/iam"

  environment    = var.environment
  aws_account_id = "878445923420"
  github_repo    = "https://github.com/dhuriyapawan/apicognito.git"
}

module "security_groups" {
  source = "../../modules/security_groups"

  vpc_id      = module.vpc.vpc_id
  environment = var.environment

  # ssh_allowed_cidrs = ["YOUR_PUBLIC_IP/32"]
}

module "rds" {
  source = "../../modules/rds"

  name        = " "
  environment = var.environment

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  db_name  = "db"
  username = "admin"
  password = "Abc123!@"

  allowed_security_group_ids = [module.eks.cluster_security_group_id]
}

module "redis" {
  source = "../../modules/redis"

  name        = "app-redis"
  environment = var.environment

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  allowed_security_group_ids = [
    module.eks.cluster_security_group_id
  ]
}

module "ecr" {
  source = "../../modules/ecr"

  name        = "app-service"
  environment = var.environment
}

module "eks" {
  source = "../../modules/eks"

  cluster_name       = "app-eks"
  environment        = var.environment
  private_subnet_ids = module.vpc.private_subnet_ids

  desired_size = 2
  max_size     = 4
  min_size     = 1
}