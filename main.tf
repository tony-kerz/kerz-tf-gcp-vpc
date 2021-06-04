terraform {
  backend "gcs" {}
  required_providers {
    # google-beta = {
    #   version = "~> 3.65.0"
    # }
    google = {}
  }
}

# provider "google-beta" {
#   #project = local.project
#   region = var.region
# }


locals {
  env     = terraform.workspace
  name    = "${var.tenant}-${local.env}"
  project = local.name
}

resource "google_project_service" "this" {
  for_each = toset(var.apis)
  #project  = local.project
  service = each.value
}



