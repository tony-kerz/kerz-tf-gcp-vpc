resource "google_compute_network" "this" {
  project                 = local.project
  name                    = local.name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  mtu                     = 1460
}

# googleapi: Error 403: Required 'compute.organizations.enableXpnHost' permission
#
#resource "google_compute_shared_vpc_host_project" "this" {
#  project    = local.project-id
#  depends_on = [google_compute_network.this]
#}

resource "google_compute_subnetwork" "this" {
  for_each                 = var.subnets
  project                  = local.project
  name                     = each.key
  ip_cidr_range            = each.value.cidr
  region                   = var.region
  network                  = google_compute_network.this.id
  private_ip_google_access = true

  dynamic "secondary_ip_range" {
    for_each = each.value.secondary-cidrs
    content {
      range_name    = secondary_ip_range.key
      ip_cidr_range = secondary_ip_range.value
    }
  }
}
