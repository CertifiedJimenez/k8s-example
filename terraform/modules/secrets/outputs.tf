output "eso_role_arn" {
  value       = module.eso_irsa.iam_role_arn
  description = "IRSA role ARN for External Secrets Operator"
}

output "wordpress_secret_arn" {
  value       = aws_secretsmanager_secret.wordpress.arn
  description = "ARN of the WordPress GSM secret"
}
