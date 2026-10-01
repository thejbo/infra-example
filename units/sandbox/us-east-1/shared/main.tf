module "acm_certs" {
  source   = "${var.module_root}/acm-certs"
  for_each = toset(local.account.acm_certs)

  domain = each.key
}
output "acm_certs" {
  value = module.acm_certs
}
