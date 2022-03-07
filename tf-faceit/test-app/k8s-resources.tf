resource "kubernetes_namespace" "test_app" {
  metadata {
    name = "test-app"
  }
}

resource "kubernetes_secret" "test_app" {
  metadata {
    name      = "test-app"
    namespace = kubernetes_namespace.test_app.metadata[0].name
  }

  data = {
    # POSTGRESQL_HOST     = google_sql_database_instance.test_app_production.private_ip_address
    POSTGRESQL_USER     = google_sql_user.test_app_production.name
    POSTGRESQL_PASSWORD = google_sql_user.test_app_production.password
    POSTGRESQL_DBNAME   = google_sql_database.test_app_production.name
  }
}
