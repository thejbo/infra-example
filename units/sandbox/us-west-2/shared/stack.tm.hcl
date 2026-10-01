stack {
  name        = "shared"
  description = "shared"
  id          = "4f97d44d-7cfa-4566-931b-40ca25f4b67f"
}

/*
output "acm_certs" {
  backend = "default"
  value   = module.acm_certs
}
*/

input "us_west_2_public_vpc" {
  backend       = "default"
  from_stack_id = "422ac841-448b-41de-b160-ce4d1dda0577"
  value         = outputs.vpc.value
}

input "us_west_2_private_vpc" {
  backend       = "default"
  from_stack_id = "b8d41fed-ecaa-4124-b756-e66f7e23452f"
  value         = outputs.vpc.value
}

input "us_east_1_public_vpc" {
  backend       = "default"
  from_stack_id = "368ac91f-80c3-4078-a80c-c00d5f963b19"
  value         = outputs.vpc.value
}

input "us_east_1_private_vpc" {
  backend       = "default"
  from_stack_id = "c6e3a917-68cd-4858-9343-f90d8661e7c0"
  value         = outputs.vpc.value
}

input "us_east_2_public_vpc" {
  backend       = "default"
  from_stack_id = "6607c0db-3221-4128-9fc4-484c0cf6a055"
  value         = outputs.vpc.value
}

input "us_east_2_private_vpc" {
  backend       = "default"
  from_stack_id = "645e701b-ebe9-491f-8a21-750c5782e4d6"
  value         = outputs.vpc.value
}
