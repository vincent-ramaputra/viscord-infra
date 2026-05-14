
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