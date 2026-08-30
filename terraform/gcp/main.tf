terraform {
  cloud {
    organization = "vincent_solo_team"

    workspaces {
      name = "dev"
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
  region = "asia-southeast2"
  zone    = "asia-southeast2-a"
}