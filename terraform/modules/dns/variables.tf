variable "domain" {
  type        = string
  description = "Root domain — Route53 hosted zone must already exist"
}

variable "blog_fqdn" {
  type        = string
  description = "FQDN for the blog"
}

variable "alb_hostname" {
  type        = string
  description = "ALB hostname — leave empty on first apply, populate after ALB is created"
  default     = ""
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name — used to namespace SSM parameters"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources"
}

variable "create_zone" {
  type        = bool
  description = "Set true to create the Route53 hosted zone. After apply, point your registrar NS records at the outputs.name_servers values."
  default     = false
}
