resource "google_compute_instance" "tf-vm" {
  name         = "tf-vm"
  zone         = "us-central1-c"
  machine_type = "n1-standard-1"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  # Add SSH access to the Compute Engine instance
  metadata = {
    ssh-keys = "${var.gcp-username}:${file("~/.ssh/id_rsa.pub")}"
  }

  # Add http tag to the instance to identify it in the firewall rule
  tags = ["http"]

  # Startup script
  metadata_startup_script = file("setup-docker.sh")

  network_interface {
    network    = var.gcp-network
    subnetwork = var.gcp-network

    access_config {}
  }
}

output "tf-vm-internal-ip" {
  value      = google_compute_instance.tf-vm.network_interface.0.network_ip
  depends_on = [google_compute_instance.tf-vm]
}

output "tf-vm-ephemeral-ip" {
  value      = google_compute_instance.tf-vm.network_interface.0.access_config.0.nat_ip
  depends_on = [google_compute_instance.tf-vm]
}
