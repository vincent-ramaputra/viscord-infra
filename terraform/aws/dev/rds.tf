 data "aws_db_instance" "app_db" {
    db_instance_identifier = "viscord-dev"
}


resource "aws_db_subnet_group" "app_db_group" {
    name = "dev-app-db-group"
    subnet_ids = module.dev_vpc.private_subnet_ids
}

resource "aws_security_group" "rds" {
    name   = "viscord-dev-rds"
    vpc_id = module.dev_vpc.vpc_id
  }

  resource "aws_vpc_security_group_ingress_rule" "rds_from_cluster" {
    security_group_id            = aws_security_group.rds.id
    referenced_security_group_id = module.app_cluster.node_security_group_id
    ip_protocol                  = "tcp"
    from_port                    = 5432
    to_port                      = 5432
  }
