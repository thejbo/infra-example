module "vpc" {
  source = "${var.module_root}/vpc"

  tags                = local.scope
  name                = lower("${local.regions[local.scope.region]}-${local.scope.vpc}")
  cidr                = local.networks[local.scope.account][local.scope.region][local.scope.vpc].cidr
  region              = local.scope.region
  subnets             = local.networks[local.scope.account][local.scope.region][local.scope.vpc].zones
  internet_gw_enabled = false
}
