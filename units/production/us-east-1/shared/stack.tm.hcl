stack {
  name        = "shared"
  description = "shared"
  id          = "5053a2ea-af04-4e5a-b4b8-99a12a458e0f"
}

output "acm_certs" {
  backend = "default"
  value   = module.acm_certs
}
