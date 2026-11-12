locals {

  s3_bucket_name = "${var.project}-${var.env}-tfstate-123"

  common_tags = {
    Project     = var.project
    Environment = var.env
    Terraform   = "True"
  }

}
