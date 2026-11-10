terraform {

  # Minimum Terraform CLI version required
  # required_version = ">= 1.12.0"

  # Required providers and version constraints
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"   # "~> 5.0"
    }
  }

  # Remote Backend
  backend "s3" {
    bucket         = "shopverse-dev-tfstate-123"
    key            = "shopverse-vpc-eks/terraform.tfstate"
    region         = "us-east-1"
    # encrypt        = true
    use_lockfile   = true   # Enables native S3 state locking (Terraform 1.10+)
  }

}

provider "aws" {
  # AWS region to use for all resources to be created in (from variables)
  region = var.region     # "us-east-1"

  # default_tags {
  #   tags = {
  #     Project     = "shopverse"
  #     Env         = "dev"
  #     ManagedBy   = "terraform"
  #   }
  # }
}
