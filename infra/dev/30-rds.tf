module "rds_postgre_sg" {
  source = "git::https://github.com/vaheedgit26/Infra-1.0.git//modules/sg"

  vpc_id         = module.vpc.vpc_id
  sg_name        = "${local.resource_name}-rds-postgre-sg"
  sg_description = "Postgre RDS Instance Security Group"

  common_tags    = local.common_tags
}

# bastion (public_subnet) ---> postgre (database_subnet)
resource "aws_security_group_rule" "bastion_to_postgre" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = module.rds_postgre_sg.sg_id

  # depends_on = [module.bastion_sg]
}

# EKS cluster  --->  postgre (database_subnet)
resource "aws_security_group_rule" "backend_to_postgre" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = module.eks.node_security_group_id
  security_group_id        = module.rds_postgre_sg.sg_id

  # depends_on = [module.backend_sg]
}

module "rds" {
  source = "git::https://github.com/vaheedgit26/Infra-1.0.git//modules/rds"
  env    = var.env     # For snapshot, deletion_protection settings
  database_subnet_ids  = module.vpc.database_subnet_ids     # For subnet group creation

  identifier              = local.identifier
  availability_zone       = local.availability_zone        # var.availability_zone
  engine                  = "postgres"
  engine_version          = "15.7"
  instance_class          = "db.t3.micro"
  allocated_storage       = 10       # 20
  storage_type            = "gp2"
  storage_encrypted       = false    # true
  db_name                 = "ecommercedb"
  db_username             = local.ecommerce_secret_json.username
  db_password             = local.ecommerce_secret_json.password
  db_subnet_group_name    = local.db_subnet_group_name
  vpc_security_group_ids  = [module.rds_postgre_sg.sg_id]

  common_tags = local.common_tags

  depends_on = [ module.rds_postgre_sg, aws_security_group_rule.bastion_to_postgre, aws_security_group_rule.backend_to_postgre ]
}
