resource "google_service_account" "test_app" {
  account_id   = "test-app"
  display_name = "Test App"
}

resource "google_service_account_iam_member" "test_app" {
  service_account_id = google_service_account.test_app.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.faceit_project_id}.svc.id.goog[${kubernetes_namespace.test_app.metadata[0].name}/test-app]"
}

resource "google_project_iam_member" "test_app" {
  role   = "roles/cloudsql.client"
  member = "serviceAccount:${google_service_account.test_app.email}"
}
