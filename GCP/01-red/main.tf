resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

## Añadir regla icmp de firewall

resource "google_compute_firewall" "firewall-icmp" {
  name    = "terraform-allow-icmp"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
}

## Añadir regla tcp de firewall para SSH

resource "google_compute_firewall" "firewall-ssh" {
  name    = "terraform-allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

## Añadir reglas tcp, udp e icmp de firewall para permitir tráfico interno en todos los puertos en la subred us-central1 (10.128.0.0/20)

resource "google_compute_firewall" "firewall-internal" {
  name    = "terraform-allow-internal"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = ["10.128.0.0/20"]
}



