stack {
  name        = "vpc"
  description = "vpc"
  id          = "645e701b-ebe9-491f-8a21-750c5782e4d6"
}

output "vpc" {
  backend = "default"
  value   = module.vpc
}
