variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to deploy the EKS cluster into"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnet IDs for EKS nodes"
}

variable "node_type" {
  type        = string
  default     = "t3.small"
  description = "EKS node instance type"
}

variable "node_count" {
  type        = number
  default     = 2
  description = "Desired EKS node count"
}
