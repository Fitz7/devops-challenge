terraform {
  backend "gcs" {
    bucket = "fitz-faceit-terraform"
    prefix = "terraform/state"
  }
  required_providers {
    circleci = {
      source  = "mrolla/circleci"
      version = "0.6.1"
    }
  }
}
