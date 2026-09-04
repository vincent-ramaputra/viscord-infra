# resource "aws_db_instance" "app_db" {
#     identifier = "viscord-dev"

#     engine = "postgres"
#     engine_version = "18.3"
#     username = "admin"
#     manage_master_user_password = true

#     allocated_storage = 10
#     instance_class = "db.t4g.micro"
#     skip_final_snapshot = true
# }

# resource ""`