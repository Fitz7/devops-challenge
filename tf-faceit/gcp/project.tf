data "google_project" "project" {
  project_id = var.faceit_project_id
}

resource "google_project_service" "service" {
  for_each = toset([
    "container.googleapis.com",
    "artifactregistry.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "servicenetworking.googleapis.com"
  ])

  service = each.key

  project            = data.google_project.project.project_id
  disable_on_destroy = false
}
