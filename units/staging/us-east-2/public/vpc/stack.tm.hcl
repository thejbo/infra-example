stack {
  name        = "vpc"
  description = "vpc"
  id          = "d2345d45-c491-44ae-970c-d46f2a849a94"
}

output "vpc" {
  backend = "default"
  value   = module.vpc
}
