variable "project" { default = "shopverse" }
variable "env"     { default = "dev" }
variable "region"  { default = "us-east-1" }

variable "remote_state_s3_bucket"     { default = "shopverse-dev-tfstate-123" }       # To read VPC and EKS output values
variable "remote_state_s3_bucket_key" { default = "shopverse-vpc-eks/terraform.tfstate" }
