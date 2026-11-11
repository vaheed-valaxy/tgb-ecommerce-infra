locals {
  resource_name = "${var.project}-${var.env}"

  common_tags = {
    Project     = var.project
    Environment = var.env
    Terraform   = "True"
  }

  bastion_sg_name = "${local.resource_name}-bastion-sg"
  bastion_sg_id   = module.bastion_sg.sg_id
  alb_sg_name     = "${local.resource_name}-alb-sg"

  eks_cluster_name       = "${local.resource_name}-eks-cluster"            # ecommerce-dev-eks-cluster
  eks_cluster_subnet_ids = module.vpc.private_subnet_ids
  eks_node_subnet_ids    = module.vpc.private_subnet_ids

  eks_vpc_public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"          # "shared"
  }

  eks_vpc_private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"           # "shared"
  }

  node_auto_scaler_tags = {
    "k8s.io/cluster-autoscaler/enabled"                   = "true"
    "k8s.io/cluster-autoscaler/${local.eks_cluster_name}" = "owned"
  }

  aws_secret_name = "/${var.project}/${var.env}/postgre-jwt-credentials"      # /ecommerce/dev/postgre-jwt-credentials

  # RDS Variables
  identifier                 = "${local.resource_name}-postgre"
  availability_zone          = module.vpc.availability_zones[0]
  shopverse_secret_json      = jsondecode(data.aws_secretsmanager_secret_version.ecommerce_secret_value.secret_string)
  db_subnet_group_name       = "${local.resource_name}-postgre-rds-db-subnet-group"
  
  # rds_vpc_security_group_ids = [module.eks.cluster_security_group_id, module.bastion_sg.sg_id]

  # ALB Target Groups
  microservices = {
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

}
