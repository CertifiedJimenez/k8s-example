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

module "external_dns_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name                     = "${var.cluster_name}-external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = var.hosted_zone_arns

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:external-dns"]
    }
  }
}

resource "aws_ssm_parameter" "alb_controller_role_arn" {
  name  = "/${var.cluster_name}/alb-controller-role-arn"
  type  = "String"
  value = module.alb_controller_irsa.iam_role_arn
}

resource "aws_ssm_parameter" "external_dns_role_arn" {
  name  = "/${var.cluster_name}/external-dns-role-arn"
  type  = "String"
  value = module.external_dns_irsa.iam_role_arn
}
