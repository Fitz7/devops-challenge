resource "google_artifact_registry_repository" "docker_registry_repo" {
  provider      = google-beta
  project       = data.google_project.project.project_id
  location      = "europe-west1"
  repository_id = "docker"
  description   = "docker repository"
  format        = "DOCKER"
}

module "artifact-registry-repository-iam-bindings" {
  source       = "terraform-google-modules/iam/google//modules/artifact_registry_iam"
  version      = "~> 7.4"
  project      = data.google_project.project.project_id
  repositories = [google_artifact_registry_repository.docker_registry_repo.name]
  location     = google_artifact_registry_repository.docker_registry_repo.location
  mode         = "authoritative"

  bindings = {
    "roles/artifactregistry.writer" = [
      "serviceAccount:${var.circleci_container_pusher_sa_email}",
    ],
    "roles/artifactregistry.reader" = [
      "serviceAccount:${google_service_account.kubernetes.email}",
    ]
  }
}
