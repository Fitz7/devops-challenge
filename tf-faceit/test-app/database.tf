data "google_compute_network" "network" {
  name    = "default"
  project = var.faceit_project_id
}

resource "google_compute_global_address" "test_app_production" {
  # provider = google-beta

  name          = "test-app-production"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.network.id
}

resource "google_service_networking_connection" "test_app_production" {
  # provider = google-beta

  network                 = data.google_compute_network.network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.test_app_production.name]
}


resource "google_sql_database_instance" "test_app_production" {
  name             = "test-app-production"
  database_version = "POSTGRES_11"
  region           = "europe-west1"
  depends_on       = [google_service_networking_connection.test_app_production]

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled    = false
      private_network = data.google_compute_network.network.id
    }
  }
}

resource "google_sql_database" "test_app_production" {
  name     = "test-app"
  instance = google_sql_database_instance.test_app_production.name
}

resource "random_password" "test_app_production" {
  length = 24
}

resource "google_sql_user" "test_app_production" {
  name     = "test-app-production-user"
  instance = google_sql_database_instance.test_app_production.name
  password = random_password.test_app_production.result
}
