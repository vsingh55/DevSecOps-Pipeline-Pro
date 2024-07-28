resource "google_compute_firewall" "allow_custom" {
  name        = "${var.network}-allow-custom"
  project     = var.gcp_project_id
  network     = var.network
  direction   = "INGRESS"
  priority    = 65534
  source_ranges = ["10.128.0.0/9", "0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "465", "6443", "3000-10000", "30000-32767"]
  }
}

resource "google_compute_firewall" "allow_icmp" {
  name        = "${var.network}-allow-icmp"
  project     = var.gcp_project_id
  network     = var.network
  direction   = "INGRESS"
  priority    = 65534
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "icmp"
  }
}

resource "google_compute_firewall" "allow_ssh" {
  name        = "${var.network}-allow-ssh"
  project     = var.gcp_project_id
  network     = var.network
  direction   = "INGRESS"
  priority    = 65534
  source_ranges = ["0.0.0.0/0"]
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}
