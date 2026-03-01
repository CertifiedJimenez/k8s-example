# If create_zone = true  → Terraform creates the zone, outputs nameservers to add at your registrar
# If create_zone = false → zone already exists and is delegated; Terraform just reads it
resource "aws_route53_zone" "this" {
  count = var.create_zone ? 1 : 0
  name  = var.domain
  tags  = var.tags
}

data "aws_route53_zone" "this" {
  count        = var.create_zone ? 0 : 1
  name         = var.domain
  private_zone = false
}

locals {
  zone_id = var.create_zone ? aws_route53_zone.this[0].zone_id : data.aws_route53_zone.this[0].zone_id
}

resource "aws_acm_certificate" "this" {
  domain_name               = var.domain
  subject_alternative_names = ["*.${var.domain}"]
  validation_method         = "DNS"
  tags                      = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => dvo
  }

  zone_id         = local.zone_id
  name            = each.value.resource_record_name
  type            = each.value.resource_record_type
  ttl             = 60
  records         = [each.value.resource_record_value]
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}

# Skipped on first apply — set alb_hostname after the LB controller creates the ALB
resource "aws_route53_record" "blog" {
  count = var.alb_hostname != "" ? 1 : 0

  zone_id = local.zone_id
  name    = var.blog_fqdn
  type    = "CNAME"
  ttl     = 300
  records = [var.alb_hostname]
}

# SSM bridge — helmfile reads this at sync time, no terraform coupling
resource "aws_ssm_parameter" "certificate_arn" {
  name  = "/${var.cluster_name}/certificate-arn"
  type  = "String"
  value = aws_acm_certificate_validation.this.certificate_arn
  tags  = var.tags
}
