resource "google_container_cluster" "dev_cluster" {
  name = "dev-cluster"
  location = "asia-southeast2-a"
  deletion_protection = false

  remove_default_node_pool = true
  initial_node_count       = 1

  network = google_compute_network.dev_network.id
  subnetwork = google_compute_subnetwork.dev_subnet.id
  workload_identity_config {
    workload_pool = "project-d29ff022-8c65-49c1-9db.svc.id.goog"
  }

  node_config {
    service_account = "gke-node@project-d29ff022-8c65-49c1-9db.iam.gserviceaccount.com"
    spot = true
  }

}
