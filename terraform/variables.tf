variable "cluster_name" {
  default = "k8s-test"
}

variable "region" {
  default = "us-east-1"
}

variable "node_type" {
  default = "t3.small"
}

variable "node_count" {
  default = 2
}

variable "bedrock_user_name" {
  description = "IAM user name for Bedrock API key"
  default     = "bedrock-api-key-user"
}
