module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.35"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  enable_cluster_creator_admin_permissions = true

  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  eks_managed_node_groups = {
    default = {
      instance_types = [var.node_type]
      min_size       = var.node_count
      max_size       = 3
      desired_size   = var.node_count
      subnet_ids     = var.private_subnets
    }
  }
}
