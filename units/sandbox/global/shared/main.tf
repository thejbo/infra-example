module "dns_zones" {
  source   = "${var.module_root}/dns-zones"
  for_each = local.account.dns_zones

  domain = each.key
  tags   = local.scope
}
output "dns_zones" {
  value = module.dns_zones
}
