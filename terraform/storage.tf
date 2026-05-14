resource "google_storage_bucket" "viscord_dev" {
  name                        = "viscord-dev"
  location                    = "ASIA-SOUTHEAST1"
  storage_class               = "STANDARD"
  force_destroy               = true
  uniform_bucket_level_access = true
  cors {
    max_age_seconds = 3600
    method = [
      "GET"
    ]
    origin = ["https://dev.viscord.app"]
  }
}

resource "google_storage_bucket" "loki_chunks_dev" {
  name                        = "loki-chunks-dev"
  location                    = "asia-southeast1"
  storage_class               = "standard"
  force_destroy               = true
  uniform_bucket_level_access = true

  lifecycle_rule {
    condition { age = 14 }
    action {
      type          = "SetStorageClass"
      storage_class = "nearline"
    }
  }

  lifecycle_rule {
    condition { age = 44 }
    action {
      type = "Delete"
    }
  }

}

resource "google_storage_bucket" "loki_ruler_dev" {
  name                        = "loki-ruler-dev"
  location                    = "asia-southeast1"
  storage_class               = "standard"
  force_destroy               = true
  uniform_bucket_level_access = true
}


resource "google_storage_bucket_iam_binding" "public_read" {
  bucket = google_storage_bucket.viscord_dev.name
  role   = "roles/storage.objectViewer"

  members = [
    "allUsers"
  ]
}
