stack {
  name        = "vpc"
  description = "vpc"
  id          = "279241cb-47c0-431d-b31a-8893dc86b859"
}

output "vpc" {
  backend = "default"
  value   = module.vpc
}
