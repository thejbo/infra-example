stack {
  name        = "vpc"
  description = "vpc"
  id          = "bc8d3cc0-6484-438d-8008-65a380858097"
}

output "vpc" {
  backend = "default"
  value   = module.vpc
}
