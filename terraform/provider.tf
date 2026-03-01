terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket         = "certifiedjimenez-k8s-tf-state"
    key            = "k8s-test/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "devops-k8s-tf-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}