stack {
  name        = "vpc"
  description = "vpc"
  id          = "368ac91f-80c3-4078-a80c-c00d5f963b19"
}

output "vpc" {
  backend = "default"
  value   = module.vpc
}
