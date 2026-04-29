resource "google_storage_bucket" "viscord_dev" {
    name          = "viscord-dev"
    location      = "ASIA-SOUTHEAST1"
    storage_class = "STANDARD"
    force_destroy = true
    uniform_bucket_level_access = true
}