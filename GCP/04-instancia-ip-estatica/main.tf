resource "google_compute_address" "tf-vm-ip" {
  name = "ipv4-address-tf-vm"
}

resource "google_compute_instance" "tf-vm" {
  name         = "tf-vm"
  machine_type = "n1-standard-1"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  # Add SSH access to the Compute Engine instance
  metadata = {
    ssh-keys = "${var.gcp-username}:${file("~/.ssh/id_rsa.pub")}"
  }

  # Startup script
  # metadata_startup_script = "${file("update-docker.sh")}"

  network_interface {
    network    = var.gcp-network
    subnetwork = var.gcp-network

    access_config {
      nat_ip = google_compute_address.tf-vm-ip.address
    }
  }
}

output "tf-vm-ip" {
  value      = google_compute_address.tf-vm-ip.address
  depends_on = [google_compute_instance.tf-vm]
}
