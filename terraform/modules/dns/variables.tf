variable "domain" {
  type        = string
  description = "Root domain — Route53 hosted zone must already exist"
}

variable "blog_fqdn" {
  type        = string
  description = "FQDN for the blog"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name — used to namespace SSM parameters"
}

variable "create_zone" {
  type        = bool
  description = "Set true to create the Route53 hosted zone."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources"
}
