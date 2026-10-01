stack {
  name        = "vpc"
  description = "vpc"
  id          = "b4399a18-3cc5-43d8-91d1-7a86060e95b8"
}

output "vpc" {
  backend = "default"
  value   = module.vpc
}
