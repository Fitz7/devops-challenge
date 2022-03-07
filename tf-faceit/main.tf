module "gcp" {
  source = "./gcp"

  faceit_project_id                  = local.faceit_project_id
  circleci_container_pusher_sa_email = module.circleci.circleci_container_pusher_sa.email
  circleci_terraformer_sa_email      = module.circleci.circleci_terraformer_sa.email
}

module "circleci" {
  source            = "./circleci"
  faceit_project_id = local.faceit_project_id
  providers = {
    circleci = circleci
  }
}

module "test-app" {
  source = "./test-app"

  faceit_project_id = local.faceit_project_id
}
