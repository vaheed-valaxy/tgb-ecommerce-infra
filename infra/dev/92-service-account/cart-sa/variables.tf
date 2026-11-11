variable "project" {}
variable "env" {}
variable "region" {}

variable "remote_state_s3_bucket"     { default = "ecommerce-dev-tfstate-123" }
variable "remote_state_s3_bucket_key" { default = "ecommerce-vpc-eks/terraform.tfstate" }

variable "namespace" { "ecommerce-dev" }
variable "service_account" { default = "cart-sa" }
variable "dynamodb_table" { default = "ecommerce-cart" }
