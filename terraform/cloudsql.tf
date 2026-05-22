resource "google_sql_database_instance" "viscord_dev" {
    name = "viscord-dev"
    database_version = "POSTGRES_18"
    settings {
        edition = "ENTERPRISE"
        tier = "db-g1-small"
        disk_autoresize = false
        enable_dataplex_integration = true

        database_flags {
          name = "cloudsql.iam_authentication"
          value = "on"
        }

        final_backup_config {
          enabled = false
        }

        ip_configuration {
          ipv4_enabled = false
          private_network = google_compute_network.dev_network.self_link
        }
    }
}
