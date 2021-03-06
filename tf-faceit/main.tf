module "gcp" {
  source = "./gcp"

  faceit_project_id                  = local.faceit_project_id
  circleci_container_pusher_sa_email = module.circleci.circleci_container_pusher_sa.email
  circleci_terraformer_sa_email      = module.circleci.circleci_terraformer_sa.email
  circleci_k8s_releaser_sa_email     = module.circleci.circleci_k8s_releaser_sa.email
}

module "circleci" {
  source            = "./circleci"
  faceit_project_id = local.faceit_project_id
  providers = {
    circleci = circleci
  }
}

module "test_app" {
  source = "./test-app"

  faceit_project_id  = local.faceit_project_id
  test_app_namespace = module.gcp.test_app_namespace
  network            = module.gcp.network_id
  subnet             = module.gcp.eu_west1_01_subnet_id
}
