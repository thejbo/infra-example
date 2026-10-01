stack {
  name        = "vpc"
  description = "vpc"
  id          = "b8d41fed-ecaa-4124-b756-e66f7e23452f"
}

output "vpc" {
  backend = "default"
  value   = module.vpc
}
