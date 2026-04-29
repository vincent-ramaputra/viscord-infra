resource "google_storage_bucket" "viscord_dev" {
    name = "viscord_dev"
    location = "asia-southeast1-a"
    force_destroy = true
}