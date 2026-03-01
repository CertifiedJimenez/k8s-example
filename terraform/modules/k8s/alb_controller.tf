module "alb_controller_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                              = "${var.cluster_name}-alb-controller"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

# SSM bridge — helmfile reads this at sync time, no terraform coupling
resource "aws_ssm_parameter" "alb_controller_role_arn" {
  name  = "/${var.cluster_name}/alb-controller-role-arn"
  type  = "String"
  value = module.alb_controller_irsa.iam_role_arn
}
