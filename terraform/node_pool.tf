resource "google_container_node_pool" "dev_pool" {
  name       = "dev-pool"
  cluster    = google_container_cluster.dev_cluster.name
  node_count = 3

  node_config {
    spot         = true
    machine_type = "e2-small"
    service_account = "gke-node@project-d29ff022-8c65-49c1-9db.iam.gserviceaccount.com"

    boot_disk {
      disk_type = "pd-standard"
      size_gb   = 40
    }
  }
}