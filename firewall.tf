# resource "google_compute_firewall" "this" {
#   name    = local.name
#   network = google_compute_network.this.name
#   dynamic "allow" {
#     for_each = local.allow
#     content {
#       protocol = allow.value.protocol
#       ports    = allow.value.ports
#     }
#   }
# }
