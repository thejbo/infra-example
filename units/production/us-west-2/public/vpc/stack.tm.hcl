stack {
  name        = "vpc"
  description = "vpc"
  id          = "6cc6bb61-686e-4aec-9c32-5c8c626356c9"
}

output "vpc" {
  backend = "default"
  value   = module.vpc
}
