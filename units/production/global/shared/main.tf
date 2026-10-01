/*
data "hiera5_json" "scope" {
  key = "scope"
}

data "hiera5_json" "account" {
  key = "account"
}

locals {
  scope   = jsondecode(data.hiera5_json.scope.value)
  account = jsondecode(data.hiera5_json.account.value)
}
*/

module "base_account" {
  source = "${var.module_root}/base-account"

  tags = local.scope
}

module "dns_zones" {
  source   = "${var.module_root}/dns-zones"
  for_each = local.account.dns_zones

  domain = each.key
  tags   = local.scope
}

/*
module "acm_certs_US_WEST_2" {
  providers = {
    aws = aws.by_region["us-west-2"]
  }

  source   = "${var.module_root}/acm-certs"
  for_each = toset(local.account.acm_certs.us-west-2)

  domain = each.key
}
output "acm_certs_US_WEST_2" {
  value = module.acm_certs_US_WEST_2
}


module "acm_certs_US_EAST_1" {
  providers = {
    aws = aws.by_region["us-east-1"]
  }

  source   = "${var.module_root}/acm-certs"
  for_each = toset(local.account.acm_certs.us-east-1)

  domain = each.key
}
output "acm_certs_US_EAST_1" {
  value = module.acm_certs_US_EAST_1
}

*/
