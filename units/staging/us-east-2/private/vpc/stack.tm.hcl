stack {
  name        = "vpc"
  description = "vpc"
  id          = "cd7bab73-0994-4e1b-97b3-1446cd18dc50"
}

output "vpc" {
  backend = "default"
  value   = module.vpc
}
