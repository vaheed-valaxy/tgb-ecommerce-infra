module "secrets_manager" {
  source = "git::https://github.com/vaheedgit26/Infra-1.0.git//modules/secrets-manager"

  project        = var.project                        # "ecommerce"
  env            = var.env                            # "dev"
  
  db_secret_name = local.aws_secret_name              # /shopverse/dev/mysql-jwt-credentials
  
  db_username    = var.db_username
  db_password    = var.db_password
  jwt_secret     = var.jwt_secret

  common_tags = local.common_tags
}
