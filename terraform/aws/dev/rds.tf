data "aws_db_instance" "app_db" {
    db_instance_identifier = "viscord-dev"
}

data "aws_security_group" "app_db" {
    name = "viscord-dev-rds"
}
