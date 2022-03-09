locals {
  eu_west1_01_subnet_region = "europe-west1"
  eu_west1_01_subnet_name   = "eu-west1-01"
  eu_west1_01_cidr          = "10.10.0.0/16"
  pods_cidr                 = "10.20.0.0/14"
  pods_range_name           = "primary-pods"
  services_cidr             = "10.24.0.0/20"
  services_range_name   = "primary-services"
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 4.0"

  project_id   = var.faceit_project_id
  network_name = "primary"
  routing_mode = "GLOBAL"
  subnets = [
    {
      subnet_name           = local.eu_west1_01_subnet_name
      subnet_ip             = local.eu_west1_01_cidr
      subnet_region         = local.eu_west1_01_subnet_region
      subnet_private_access = "true"
    }
  ]

  secondary_ranges = {
    eu-west1-01 = [
      {
        range_name    = "primary-pods"
        ip_cidr_range = local.pods_cidr
      },
      {
        range_name    = "primary-services"
        ip_cidr_range = local.services_cidr
      },
    ]
  }
}

output "network_id" {
  value = module.vpc.network_id
}

output "eu_west1_01_subnet_id" {
  value = module.vpc.subnets["${local.eu_west1_01_subnet_region}/${local.eu_west1_01_subnet_name}"].id
}
