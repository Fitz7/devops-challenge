
variable "billing_account" {}
variable "org_id" {}

locals {
  faceit_region       = "eu-west1"
  faceit_project_name = "faceit"
}

provider "google" {
  region = local.faceit_region
}

resource "random_id" "id" {
  byte_length = 4
  prefix      = local.faceit_project_name
}

resource "google_project" "project" {
  name                = local.faceit_project_name
  project_id          = random_id.id.hex
  billing_account     = var.billing_account
  org_id              = var.org_id
  auto_create_network = false
}

output "faceit_project_id" {
  value = google_project.project.project_id
}
