#variable "aws_account_id" {}
#variable "aws_region" {}
#variable "base_account" {}
/*
data "hiera5_json" "account" {
  key = "account"
}

data "hiera5_json" "scope" {
  key = "scope"
}

data "hiera5_json" "regions" {
  key = "regions"
}

data "hiera5_json" "networks" {
  key = "networks"
}

locals {
  account  = jsondecode(data.hiera5_json.account.value)
  networks = jsondecode(data.hiera5_json.networks.value)
  scope    = jsondecode(data.hiera5_json.scope.value)
  regions  = jsondecode(data.hiera5_json.regions.value)
}
*/
/*
output "scope" {
  value = local.scope
}
*/
