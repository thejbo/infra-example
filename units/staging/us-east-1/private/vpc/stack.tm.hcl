stack {
  name        = "vpc"
  description = "vpc"
  id          = "0a187e0a-6e1f-4607-bf05-ca62d4b04629"
}

output "vpc" {
  backend = "default"
  value   = module.vpc
}
