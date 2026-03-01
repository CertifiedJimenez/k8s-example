output "certificate_arn" {
  description = "Validated ACM certificate ARN"
  value       = aws_acm_certificate_validation.this.certificate_arn
}

output "blog_fqdn" {
  description = "Blog FQDN"
  value       = var.blog_fqdn
}

output "name_servers" {
  description = "Route53 nameservers — copy these 4 NS values into your registrar as NS records to delegate DNS to AWS"
  value       = var.create_zone ? aws_route53_zone.this[0].name_servers : data.aws_route53_zone.this[0].name_servers
}
