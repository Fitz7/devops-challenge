resource "google_service_account" "kubernetes" {
  account_id   = "kubernetes"
  display_name = "Service Account"
  project      = data.google_project.project.project_id
}

resource "google_container_cluster" "primary" {
  project  = data.google_project.project.project_id
  name     = "primary"
  location = "europe-west1"

  network    = module.vpc.network_id
  subnetwork = module.vpc.subnets["${local.eu_west1_01_subnet_region}/${local.eu_west1_01_subnet_name}"].id

  ip_allocation_policy {
    cluster_secondary_range_name  = local.pods_range_name
    services_secondary_range_name = local.services_range_name
  }

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

resource "kubernetes_namespace" "test_app" {
  depends_on = [
    google_container_node_pool.primary_preemptible_nodes
  ]
  metadata {
    name = "test-app"
  }
}

output "primary_cluster" {
  value = google_container_cluster.primary
}

output "test_app_namespace" {
  value = kubernetes_namespace.test_app.metadata[0].name
}
