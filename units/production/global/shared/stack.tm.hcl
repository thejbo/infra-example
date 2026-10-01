stack {
  name        = "shared"
  description = "shared"
  id          = "1a028865-5d31-4982-b466-41c0a8c6152e"
}

output "base_account" {
  backend = "default"
  value   = module.base_account
}

output "dns_zones" {
  backend = "default"
  value   = module.dns_zones
}
