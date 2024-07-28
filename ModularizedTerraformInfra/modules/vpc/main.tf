resource "google_compute_network" "vpc_network" {
  auto_create_subnetworks = true
  description             = "VPC-DevSecOps-Pipeline-Pro"
  mtu                     = 1460
  name                    = var.gcp_network_name
  project                 = var.gcp_project_id
  routing_mode            = "REGIONAL"
}
