data "google_compute_default_service_account" "default" {
  project = data.google_project.project.project_id
}

module "projects_iam_bindings" {
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  version  = "~> 7.4"
  projects = [data.google_project.project.project_id]
  mode     = "authoritative"

  bindings = {
    "roles/editor" = [
      "serviceAccount:${var.circleci_terraformer_sa_email}",
      "serviceAccount:${data.google_compute_default_service_account.default.email}",
      "serviceAccount:${data.google_project.project.number}@cloudservices.gserviceaccount.com"
    ],
    # seems editor role is missing servicenetworking.services.addPeering
    "roles/servicenetworking.networksAdmin" = [
      "serviceAccount:${var.circleci_terraformer_sa_email}",
    ],
    "roles/iam.securityAdmin" = [
      "serviceAccount:${var.circleci_terraformer_sa_email}",
    ]
    "roles/compute.instanceAdmin.v1" = [
      "serviceAccount:${google_service_account.kubernetes.email}"
    ]
    "roles/container.developer" = [
      "serviceAccount:${var.circleci_k8s_releaser_sa_email}"
    ]
  }
}
