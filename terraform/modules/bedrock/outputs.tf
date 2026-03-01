output "bedrock_api_key_user" {
  description = "Bedrock API key username (use with service_password)"
  value       = aws_iam_service_specific_credential.bedrock.service_user_name
}

output "bedrock_api_key_secret" {
  description = "Bedrock API key (secret) - use for authentication with Bedrock API"
  value       = aws_iam_service_specific_credential.bedrock.service_password
  sensitive   = true
}
