provider "google" {
  region = local.faceit_region
}

provider "google-beta" {
  region = local.faceit_region
}

provider "circleci" {
  api_token    = var.circleci_api_token
  vcs_type     = "github"
  organization = "Fitz7"
}
