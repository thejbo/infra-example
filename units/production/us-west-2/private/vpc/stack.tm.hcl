stack {
  name        = "vpc"
  description = "vpc"
  id          = "2b68cf6e-052e-436a-92dc-9fb419ae39c9"
}


output "vpc" {
  backend = "default"
  value   = module.vpc
}
