#data "google_compute_network_endpoint_group" "test_app_eu_west1_b_neg" {
#  name       = "test-app"
#  zone       = "europe-west1-b"
#}
#data "google_compute_network_endpoint_group" "test_app_eu_west1_c_neg" {
#  name       = "test-app"
#  zone       = "europe-west1-c"
#}
#data "google_compute_network_endpoint_group" "test_app_eu_west1_d_neg" {
#  name       = "test-app"
#  zone       = "europe-west1-d"
#}
#
#resource "google_compute_backend_service" "test_app" {
#  name = "test-app"
#
#  health_checks                   = [google_compute_health_check.test_app.id]
#  connection_draining_timeout_sec = 30
#
#  dynamic "backend" {
#    for_each = toset([
#      data.google_compute_network_endpoint_group.test_app_eu_west1_b_neg.id,
#      data.google_compute_network_endpoint_group.test_app_eu_west1_c_neg.id,
#      data.google_compute_network_endpoint_group.test_app_eu_west1_d_neg.id,
#    ])
#
#    content {
#      balancing_mode        = "RATE"
#      capacity_scaler       = 1
#      group                 = backend.key
#      max_rate_per_endpoint = 10000
#      max_utilization       = 0
#    }
#  }
#}
#
#resource "google_compute_health_check" "test_app" {
#  name = "test-app"
#
#  check_interval_sec = 1
#  timeout_sec        = 1
#
#  http_health_check {
#    request_path       = "/health"
#    port_specification = "USE_SERVING_PORT"
#  }
#}
#
#resource "google_compute_firewall" "google_health_checks" {
#  name    = "health-ingress"
#  network = var.network
#
#  allow {
#    protocol = "tcp"
#    ports    = ["8080"]
#  }
#
#  source_ranges = [
#    "35.191.0.0/16",
#    "130.211.0.0/22"
#  ]
#}
#
#resource "google_compute_global_address" "test_app" {
#  name = "test-app"
#}
#
#resource "google_compute_global_forwarding_rule" "test_app_http" {
#  name       = "test-app-http"
#  target     = google_compute_target_http_proxy.test_app.id
#  port_range = "80"
#  ip_address = google_compute_global_address.test_app.address
#}
#
#resource "google_compute_target_http_proxy" "test_app" {
#  name    = "ad-server-http"
#  url_map = google_compute_url_map.test_app.id
#}
#
#resource "google_compute_url_map" "test_app" {
#  name = "test-app"
#
#  default_service = google_compute_backend_service.test_app.id
#}
