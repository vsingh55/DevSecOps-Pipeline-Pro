provider "google" {
  credentials = file(var.gcp_svc_key)
  project     = var.gcp_project_id
  region      = var.gcp_region
  zone        = var.gcp_zone
}

module "vpc" {
  source            = "./vpc"
  gcp_project_id    = var.gcp_project_id
  gcp_network_name  = "dev-cicd-vpc"
}

module "firewall" {
  source         = "./firewall"
  gcp_project_id = var.gcp_project_id
  network        = module.vpc.network
}

module "vm" {
  source                     = "./vm"
  gcp_project_id             = var.gcp_project_id
  gcp_service_account_email  = var.gcp_service_account_email
  gcp_network_name           = module.vpc.network
}
