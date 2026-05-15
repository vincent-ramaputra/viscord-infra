
resource "google_service_account" "loki_dev" {
    account_id = "loki-dev"
}

resource "google_storage_bucket_iam_member" "loki_chunks_dev" {
    bucket = google_storage_bucket.loki_chunks_dev.name
    role = "roles/storage.objectUser"
    member = "serviceAccount:${google_service_account.loki_dev.email}"
}

resource "google_storage_bucket_iam_member" "loki_ruler_dev" {
    bucket = google_storage_bucket.loki_ruler_dev.name
    role = "roles/storage.objectUser"
    member = "serviceAccount:${google_service_account.loki_dev.email}"
}

resource "google_service_account_iam_member" "loki_dev_workload_identity" {
    service_account_id = google_service_account.loki_dev.name
    role               = "roles/iam.workloadIdentityUser"
    member             = "serviceAccount:project-d29ff022-8c65-49c1-9db.svc.id.goog[loki/loki-ksa]"
  }