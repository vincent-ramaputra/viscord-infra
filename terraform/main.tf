terraform {
  cloud {
    organization = "vincent_solo_team"

    workspaces {
      name = "gke-cluster"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.20.0"
    }
  }
}

provider "google" {
  project = "project-d29ff022-8c65-49c1-9db"
  zone    = "asia-southeast2-a"
}