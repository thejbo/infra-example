stack {
  name        = "vpc"
  description = "vpc"
  id          = "c6e3a917-68cd-4858-9343-f90d8661e7c0"
}

output "vpc" {
  backend = "default"
  value   = module.vpc
}
