resource "google_compute_router" "this" {
  name    = local.name
  region  = var.region
  network = google_compute_network.this.id
  # project = local.project

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "this" {
  name                               = local.name
  router                             = google_compute_router.this.name
  region                             = google_compute_router.this.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
