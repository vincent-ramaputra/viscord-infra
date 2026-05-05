resource "google_storage_bucket" "viscord_dev" {
    name          = "viscord-dev"
    location      = "ASIA-SOUTHEAST1"
    storage_class = "STANDARD"
    force_destroy = true
    uniform_bucket_level_access = true
    cors {
        max_age_seconds = 3600
        method = [ 
            "GET"
        ]
        origin = ["https://dev.viscord.app"]
    }
}

resource "google_storage_bucket_iam_binding" "public_read" {
    bucket = google_storage_bucket.viscord_dev.name
    role = "roles/storage.objectViewer"

    members = [
        "allUsers"
    ]
}