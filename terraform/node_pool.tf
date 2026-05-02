variable "dev_node_count" {
    default = 1
}

resource "google_container_node_pool" "dev_pool" {
  name       = "dev-pool"
  cluster    = google_container_cluster.dev_cluster.name
  node_count = var.dev_node_count
  location = "asia-southeast2-a"


  node_config {
    spot         = true
    machine_type = "e2-standard-2"
    service_account = "gke-node@project-d29ff022-8c65-49c1-9db.iam.gserviceaccount.com"
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    boot_disk {
      disk_type = "pd-standard"
      size_gb   = 40
    }
  }
}
