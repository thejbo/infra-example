stack {
  name        = "shared"
  description = "shared"
  id          = "223abfd8-81e5-48a7-8c2b-79563ea733f8"
}

/*
output "acm_certs" {
  backend = "default"
  value   = module.acm_certs
}
*/

input "us_west_2_public_vpc" {
  backend       = "default"
  from_stack_id = "b4399a18-3cc5-43d8-91d1-7a86060e95b8"
  value         = outputs.vpc.value
}

input "us_west_2_private_vpc" {
  backend       = "default"
  from_stack_id = "279241cb-47c0-431d-b31a-8893dc86b859"
  value         = outputs.vpc.value
}

input "us_east_1_public_vpc" {
  backend       = "default"
  from_stack_id = "8f7339a7-7a23-498d-a0e1-30e6be079e55"
  value         = outputs.vpc.value
}

input "us_east_1_private_vpc" {
  backend       = "default"
  from_stack_id = "0a187e0a-6e1f-4607-bf05-ca62d4b04629"
  value         = outputs.vpc.value
}

input "us_east_2_public_vpc" {
  backend       = "default"
  from_stack_id = "d2345d45-c491-44ae-970c-d46f2a849a94"
  value         = outputs.vpc.value
}

input "us_east_2_private_vpc" {
  backend       = "default"
  from_stack_id = "cd7bab73-0994-4e1b-97b3-1446cd18dc50"
  value         = outputs.vpc.value
}
