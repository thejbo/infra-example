stack {
  name        = "vpc"
  description = "vpc"
  id          = "87165042-56b8-4286-bf68-616866cc6256"
}

output "vpc" {
  backend = "default"
  value   = module.vpc
}
