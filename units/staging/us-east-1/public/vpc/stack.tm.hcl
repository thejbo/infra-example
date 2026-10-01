stack {
  name        = "vpc"
  description = "vpc"
  id          = "8f7339a7-7a23-498d-a0e1-30e6be079e55"
}

output "vpc" {
  backend = "default"
  value   = module.vpc
}
