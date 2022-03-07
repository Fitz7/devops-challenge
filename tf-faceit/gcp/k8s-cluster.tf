resource "google_service_account" "kubernetes" {
  account_id   = "kubernetes"
  display_name = "Service Account"
  project      = data.google_project.project.project_id
}

resource "google_container_cluster" "primary" {
  project  = data.google_project.project.project_id
  name     = "primary"
  location = "europe-west1"

  remove_default_node_pool = true
  initial_node_count       = 1

  release_channel {
    channel = "REGULAR"
  }
  workload_identity_config {
    workload_pool = "${data.google_project.project.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "primary_preemptible_nodes" {

  project    = data.google_project.project.project_id
  name       = "primary-pool"
  location   = "europe-west1"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  depends_on = [
    module.projects_iam_bindings
  ]

  node_config {
    preemptible  = true
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.kubernetes.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

data "google_client_config" "default" {}


provider "kubernetes" {
  host                   = "https://${google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

resource "kubernetes_config_map" "example" {
  metadata {
    name = "my-config"
  }

  data = {
    api_host = "myhost:443"
    db_host  = "dbhost:5432"
  }

}
