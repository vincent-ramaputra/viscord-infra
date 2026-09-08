resource "aws_db_instance" "app_db" {
    identifier = "viscord-dev"

    engine = "postgres"
    engine_version = "18.3"
    username = "postgres"
    manage_master_user_password = true

    allocated_storage = 10
    instance_class = "db.t4g.micro"
    skip_final_snapshot = true

    db_subnet_group_name = aws_db_subnet_group.app_db_group.name
}

resource "aws_db_subnet_group" "app_db_group" {
    name = "dev-app-db-group"
    subnet_ids = module.dev_vpc.private_subnet_ids
}
