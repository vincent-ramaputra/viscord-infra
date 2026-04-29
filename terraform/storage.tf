resource "google_storage_bucket" "viscord_dev" {
    name = "viscord_dev"
    location = "ASIA-SOUTHEAST1"
    force_destroy = true
}