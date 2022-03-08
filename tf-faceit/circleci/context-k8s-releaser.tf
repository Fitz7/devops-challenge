resource "google_service_account" "k8s_releaser" {
  account_id   = "circleci-k8s-releaser"
  project      = var.faceit_project_id
  display_name = "K8s CI Service Account"
}

resource "google_service_account_key" "k8s_releaser" {
  service_account_id = google_service_account.k8s_releaser.name
}

resource "circleci_context" "k8s_releaser" {
  name = "-k8s-releaser"
}

resource "circleci_context_environment_variable" "k8s_releaser_service_key" {
  variable   = "GCLOUD_SERVICE_KEY"
  value      = base64decode(google_service_account_key.k8s_releaser.private_key)
  context_id = circleci_context.k8s_releaser.id
}

resource "circleci_context_environment_variable" "k8s_releaser_project_id" {
  variable   = "GOOGLE_PROJECT_ID"
  value      = var.faceit_project_id
  context_id = circleci_context.k8s_releaser.id
}

resource "circleci_context_environment_variable" "k8s_releaser_region" {
  variable   = "GOOGLE_COMPUTE_REGION"
  value      = "europe-west1"
  context_id = circleci_context.k8s_releaser.id
}
