locals {
  blog_fqdn = "blog.${var.domain}"

  tags = {
    Project   = var.cluster_name
    ManagedBy = "terraform"
  }
}
