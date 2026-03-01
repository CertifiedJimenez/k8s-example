output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "cluster_name" {
  value = module.k8s.cluster_name
}

output "cluster_endpoint" {
  value = module.k8s.cluster_endpoint
}

output "configure_kubectl" {
  value       = "aws eks update-kubeconfig --region ${var.region} --name ${module.k8s.cluster_name}"
  description = "Run this to configure kubectl for the cluster"
}

output "blog_url" {
  value       = "https://${module.dns.blog_fqdn}"
  description = "WordPress blog URL"
}

output "dns_name_servers" {
  value       = module.dns.name_servers
  description = "Add these 4 NS records at your registrar (Namecheap/Cloudflare/etc) to delegate DNS to AWS"
}

output "bedrock_api_key_user" {
  value = module.bedrock.bedrock_api_key_user
}

output "bedrock_api_key_secret" {
  value     = module.bedrock.bedrock_api_key_secret
  sensitive = true
}
