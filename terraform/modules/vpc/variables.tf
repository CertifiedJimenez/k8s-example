variable "name" {
  type        = string
  description = "Name prefix for the VPC and related resources"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnet CIDR blocks"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnet CIDR blocks"
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}
