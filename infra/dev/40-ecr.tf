module "ecr" {
  source = "git::https://github.com/vaheedgit26/Infra-1.0.git//modules/ecr"

  project = var.project   # "ecommerce"
  env     = var.env       # "dev"
  
  repositories = [
    "ecommerce-dev/product",
    "ecommerce-dev/cart",
    "ecommerce-dev/user",
    "ecommerce-dev/order"
  ]
  
}
