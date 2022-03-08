resource "kubernetes_secret" "test_app" {
  metadata {
    name      = "test-app"
    namespace = var.test_app_namespace
  }

  data = {
    # POSTGRESQL_HOST     = google_sql_database_instance.test_app_production.public_ip_address
    POSTGRESQL_USER     = google_sql_user.test_app_production.name
    POSTGRESQL_PASSWORD = google_sql_user.test_app_production.password
    POSTGRESQL_DBNAME   = google_sql_database.test_app_production.name
  }
}
