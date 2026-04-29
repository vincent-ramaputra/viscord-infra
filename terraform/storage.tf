resource "google_storage_bucket" "viscord_dev" {
    name = "viscord_dev"
    location = "ASIA-SOUTHEAST1-A"
    force_destroy = true
}