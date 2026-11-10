module "ecr" {
  source = "git::https://github.com/vaheedgit26/Infra-1.0.git//modules/ecr"

  project = var.project   # "shopverse"
  env     = var.env       # "dev"
  
  repositories = [
    "shopverse-dev/frontend",
    "shopverse-dev/backend"
  ]
  
}
