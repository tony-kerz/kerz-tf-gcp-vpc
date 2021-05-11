locals {
  projects = {
    lab = {
      name   = "kerz-lab",
      number = "388714972758"
    }
  }
}

# https://github.com/hashicorp/terraform-provider-google/issues/1711
#
resource "google_project_iam_binding" "this" {
  project = local.name
  role    = "roles/compute.networkUser"

  members = [
    "serviceAccount:${local.projects.lab.name}@${local.projects.lab.name}.iam.gserviceaccount.com",
    "serviceAccount:service-${local.projects.lab.number}@container-engine-robot.iam.gserviceaccount.com",
    "serviceAccount:${local.projects.lab.number}@cloudservices.gserviceaccount.com"
  ]
}

resource "google_compute_subnetwork_iam_binding" "this" {
  for_each   = var.subnets
  project    = google_compute_subnetwork.this[each.key].project
  region     = google_compute_subnetwork.this[each.key].region
  subnetwork = google_compute_subnetwork.this[each.key].name
  role       = "roles/compute.networkUser"
  members = [
    "serviceAccount:${local.projects.lab.name}@${local.projects.lab.name}.iam.gserviceaccount.com"
  ]
}
