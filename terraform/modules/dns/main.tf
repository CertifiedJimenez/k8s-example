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

# Writes validation records so ACM validates in background — no blocking wait
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

# SSM bridge — helmfile reads at sync time, no coupling between systems
resource "aws_ssm_parameter" "certificate_arn" {
  name  = "/${var.cluster_name}/certificate-arn"
  type  = "String"
  value = aws_acm_certificate.this.arn
  tags  = var.tags
}

# CNAME record is owned by external-dns running in the cluster —
# it watches the Ingress and writes this record automatically
