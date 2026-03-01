output "certificate_arn" {
  description = "ACM certificate ARN (validation happens async in background)"
  value       = aws_acm_certificate.this.arn
}

output "blog_fqdn" {
  description = "Blog FQDN"
  value       = var.blog_fqdn
}

output "name_servers" {
  description = "Copy these 4 NS values to your registrar — one-time setup to delegate DNS to AWS"
  value       = var.create_zone ? aws_route53_zone.this[0].name_servers : data.aws_route53_zone.this[0].name_servers
}

output "zone_arn" {
  description = "Route53 hosted zone ARN — passed to external-dns IRSA policy"
  value       = var.create_zone ? aws_route53_zone.this[0].arn : data.aws_route53_zone.this[0].arn
}
