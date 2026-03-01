variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "oidc_provider_arn" {
  type        = string
  description = "EKS OIDC provider ARN for IRSA"
}

# Default credentials from the Bitnami WordPress Docker image (docker.io/bitnami/wordpress)
# These are used as the initial values when creating the secret in AWS Secrets Manager
variable "wordpress_username" {
  type        = string
  description = "WordPress admin username"
  default     = "user"
}

variable "wordpress_email" {
  type        = string
  description = "WordPress admin email address"
  default     = "user@example.com"
}
