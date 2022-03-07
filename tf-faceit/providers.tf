provider "google" {
  project = local.faceit_project_id
  region  = local.faceit_region
}

provider "google-beta" {
  region = local.faceit_region
}

provider "circleci" {
  api_token    = var.circleci_api_token
  vcs_type     = "github"
  organization = "Fitz7"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gcp.primary_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gcp.primary_cluster.master_auth[0].cluster_ca_certificate)
}
