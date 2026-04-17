resource "google_container_cluster" "dev_cluster" {
  name = "dev-cluster"

  deletion_protection = false

  remove_default_node_pool = true
  initial_node_count       = 1
}
