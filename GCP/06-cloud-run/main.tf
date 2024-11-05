terraform {
  required_providers {
    google = ">= 3.3"
  }
}

provider "google" {
  version = "3.5.0"

  credentials = file("../gcp-identity.json")

  project = var.gcp-project
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_project_service" "run" {
  service = "run.googleapis.com"
}

# Deploy image to Cloud Run
resource "google_cloud_run_service" "tf-wsb" {
  name     = "tf-wsb"
  location = "us-central1"
  template {
    spec {
      containers {
        image = "gcr.io/${var.gcp-project}/${var.gcp-image}"
      }


    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Enable public access on Cloud Run service
resource "google_cloud_run_service_iam_member" "noauth" {
  location = google_cloud_run_service.tf-wsb.location
  service  = google_cloud_run_service.tf-wsb.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
# Return service URL
output "url" {
  value = google_cloud_run_service.tf-wsb.status[0].url
}
