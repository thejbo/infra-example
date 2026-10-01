stack {
  name        = "vpc"
  description = "vpc"
  id          = "dbd8d143-fc60-4676-bb24-2d5417cfeb47"
}

output "vpc" {
  backend = "default"
  value   = module.vpc
}
