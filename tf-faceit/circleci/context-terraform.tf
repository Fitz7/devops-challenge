resource "google_service_account" "circleci_terraformer" {
  account_id   = "circleci-terraformer"
  project      = var.faceit_project_id
  display_name = "Terraform CI Service Account"
}

resource "google_service_account_key" "circleci_terraformer" {
  service_account_id = google_service_account.circleci_terraformer.name
}

resource "circleci_context" "terraform" {
  name = "terraform"
}

resource "circleci_context_environment_variable" "terraform_service_key" {
  variable   = "GCLOUD_SERVICE_KEY"
  value      = base64decode(google_service_account_key.circleci_terraformer.private_key)
  context_id = circleci_context.terraform.id
}

resource "circleci_context_environment_variable" "terraform_project_id" {
  variable   = "GOOGLE_PROJECT_ID"
  value      = var.faceit_project_id
  context_id = circleci_context.terraform.id
}

resource "circleci_context_environment_variable" "terraform_region" {
  variable   = "GOOGLE_COMPUTE_REGION"
  value      = "europe-west1"
  context_id = circleci_context.terraform.id
}

resource "circleci_context_environment_variable" "terraform_creds_file" {
  variable   = "GOOGLE_APPLICATION_CREDENTIALS"
  value      = "~/repo/terraform-deploy.json"
  context_id = circleci_context.terraform.id
}
