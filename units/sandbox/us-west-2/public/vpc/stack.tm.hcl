stack {
  name        = "vpc"
  description = "vpc"
  id          = "422ac841-448b-41de-b160-ce4d1dda0577"
}

output "vpc" {
  backend = "default"
  value   = module.vpc
}
