terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.5.0"
    }
  }
}

provider "google" {
  credentials = file("../cc2025-mtorres-57a83c20e18e.json")

  project = var.gcp-project
  region  = "us-central1"
  zone    = "us-central1-c"
}
