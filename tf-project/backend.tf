terraform {
  backend "gcs" {
    bucket = "fitz-admin-terraform"
    prefix = "terraform/state"
  }
}
