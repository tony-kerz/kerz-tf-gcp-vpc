locals {
  projects = {
    lab = {
      name   = "kerz-lab",
      number = "388714972758"
    }
  }
  project-subnets = {
    for key, val in var.subnets : key => val if(lookup(val, "project", false) != false)
  }
}

# https://github.com/hashicorp/terraform-provider-google/issues/1711
#
resource "google_project_iam_binding" "this" {
  for_each = local.projects
  role     = "roles/compute.networkUser"

  members = [
    "serviceAccount:${each.value.name}@${each.value.name}.iam.gserviceaccount.com",
    "serviceAccount:service-${each.value.number}@container-engine-robot.iam.gserviceaccount.com",
    "serviceAccount:${each.value.number}@cloudservices.gserviceaccount.com"
  ]
}

resource "google_compute_subnetwork_iam_binding" "this" {
  for_each = local.project-subnets

  project    = google_compute_subnetwork.this[each.key].project
  region     = google_compute_subnetwork.this[each.key].region
  subnetwork = google_compute_subnetwork.this[each.key].name
  role       = "roles/compute.networkUser"
  members = [
    "serviceAccount:${local.projects[each.value.project].name}@${local.projects[each.value.project].name}.iam.gserviceaccount.com"
  ]
}
