provider "google" {
    project = var.gcp_project_id
    credentials = file(var.gcp_svc_key)
    region = var.gcp_region
    zone = var.gcp_zone
}

# terraform {
#     required_providers {
#         google = {
#             source  = "hashicorp/google"
#             version = "~> 4.84"
#         }
#     }
# }

