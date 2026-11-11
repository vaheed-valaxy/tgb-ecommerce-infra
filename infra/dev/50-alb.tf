# Security Group for ALB
module "alb_sg" {
  source = "git::https://github.com/vaheedgit26/Infra-1.0.git//modules/sg"

  vpc_id         = module.vpc.vpc_id
  sg_name        = local.alb_sg_name
  sg_description = "ALB Security Group"

  common_tags    = local.common_tags
}

# ALB allowing traffic from internet
resource "aws_security_group_rule" "internet_to_alb" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.alb_sg.sg_id 
}

# Allow ALB traffic to all EKS microservices
resource "aws_security_group_rule" "alb_to_eks_nodegroup" {
  for_each = local.microservices

  type                     = "ingress"
  from_port                = each.value.port
  to_port                  = each.value.port
  protocol                 = "tcp"

  security_group_id        = module.eks.node_security_group_id
  source_security_group_id = module.alb_sg.sg_id

  description = "Allow ALB traffic to ${each.key} microservice"
}

# ALB Module Calling
module "alb" {
  source = "git::https://github.com/vaheedgit26/Infra-1.0.git//modules/alb"

  alb_name     = "${local.resource_name}-alb"
  internal     = true
  alb_sg_ids   = [module.alb_sg.sg_id]
  subnets      = module.vpc.public_subnet_ids 

  target_type  = "ip"
  vpc_id       = module.vpc.vpc_id

  listener_mode = "http"    # https, http_to_https
  # acm_certificate_arn = var.acm_certificate_arn

  services = {
    # default = {
    #   tg_name       = "${local.resource_name}-product-tg"
    #   port          = 8001
    #   health_path   = "/health"
    #   path_patterns = ["/*"]
    #   priority      = 500
    # }

    product = {
      tg_name       = "${local.resource_name}-product-tg"
      port          = 8001
      health_path   = "/health"
      path_patterns = ["/products*"]
      priority      = 100
    }

    cart = {
      tg_name       = "${local.resource_name}-cart-tg"
      port          = 8002
      health_path   = "/health"
      path_patterns = ["/cart*"]   
      priority      = 200
    }

    user = {
      tg_name       = "${local.resource_name}-user-tg"
      port          = 8003
      health_path   = "/health"
      path_patterns = ["/user*"]   
      priority      = 300
    }

    order = {
      tg_name       = "${local.resource_name}-order-tg"
      port          = 8004
      health_path   = "/health"
      path_patterns = ["/order*"]   
      priority      = 400
    }
  }

  # path_patterns = ["/api/*"]

  project      = var.project
  env          = var.env
  common_tags  = local.common_tags

  depends_on = [ module.alb_sg, aws_security_group_rule.internet_to_alb, aws_security_group_rule.alb_to_eks_nodegroup ]
}
