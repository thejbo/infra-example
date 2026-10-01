stack {
  name        = "vpc"
  description = "vpc"
  id          = "df397296-befc-4e60-8eb5-48c2af654b93"
}

output "vpc" {
  backend = "default"
  value   = module.vpc
}
