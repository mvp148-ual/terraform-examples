# allow http traffic
resource "google_compute_firewall" "allow-http" {
  name    = "tf-fw-allow-http"
  network = var.gcp-network
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags   = ["http"]
  source_ranges = ["0.0.0.0/0"]
}
