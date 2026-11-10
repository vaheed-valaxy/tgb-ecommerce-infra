variable "project" { default = "ecommerce" }
variable "env"     { default = "dev" }
variable "region"  { default = "us-east-1" }

variable "remote_state_s3_bucket"     { default = "ecommerce-dev-tfstate-123" }       # To read VPC and EKS output values
variable "remote_state_s3_bucket_key" { default = "ecommerce-vpc-eks/terraform.tfstate" }
