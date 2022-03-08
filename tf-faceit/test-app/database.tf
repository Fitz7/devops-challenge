resource "random_id" "test_app_production_suffix" {
  byte_length = 4
}


resource "google_sql_database_instance" "test_app_production" {
  name             = "test-app-production-${random_id.test_app_production_suffix.hex}"
  database_version = "POSTGRES_11"
  region           = "europe-west1"

  deletion_protection = false
  settings {
    tier = "db-f1-micro"
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
