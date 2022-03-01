resource "google_service_account" "circleci_container_pusher" {
  account_id   = "circleci-container-pusher"
  project      = var.faceit_project_id
  display_name = "CI Container Pusher"
}

resource "google_service_account_key" "circleci_container_pusher" {
  service_account_id = google_service_account.circleci_container_pusher.name
}

resource "circleci_context" "container_pusher" {
  name = "container-pusher"
}

resource "circleci_context_environment_variable" "container_pusher_service_key" {
  variable   = "GCLOUD_SERVICE_KEY"
  value      = base64decode(google_service_account_key.circleci_container_pusher.private_key)
  context_id = circleci_context.container_pusher.id
}

resource "circleci_context_environment_variable" "container_pusher_project_id" {
  variable   = "GOOGLE_PROJECT_ID"
  value      = var.faceit_project_id
  context_id = circleci_context.container_pusher.id
}

resource "circleci_context_environment_variable" "container_pusher_region" {
  variable   = "GOOGLE_COMPUTE_REGION"
  value      = "europe-west1"
  context_id = circleci_context.container_pusher.id
}
