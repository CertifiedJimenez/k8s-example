provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"

  name   = var.cluster_name
  region = var.region
}

module "k8s" {
  source = "./modules/k8s"

  cluster_name    = var.cluster_name
  region          = var.region
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  node_type       = var.node_type
  node_count      = var.node_count
}

module "bedrock" {
  source = "./modules/bedrock"

  bedrock_user_name = var.bedrock_user_name
}

module "secrets" {
  source = "./modules/secrets"

  cluster_name      = var.cluster_name
  oidc_provider_arn = module.k8s.oidc_provider_arn
}
