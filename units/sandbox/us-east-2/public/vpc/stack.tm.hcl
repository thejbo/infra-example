stack {
  name        = "vpc"
  description = "vpc"
  id          = "6607c0db-3221-4128-9fc4-484c0cf6a055"
}

output "vpc" {
  backend = "default"
  value   = module.vpc
}
