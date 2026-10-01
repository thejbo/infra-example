stack {
  name        = "shared"
  description = "shared"
  id          = "629ac6d8-92d7-43eb-82fb-ca64660ed2a3"
}

output "acm_certs" {
  backend = "default"
  value   = module.acm_certs
}

input "us_west_2_public_vpc" {
  backend       = "default"
  from_stack_id = "6cc6bb61-686e-4aec-9c32-5c8c626356c9"
  value         = outputs.vpc.value
}

input "us_west_2_private_vpc" {
  backend       = "default"
  from_stack_id = "2b68cf6e-052e-436a-92dc-9fb419ae39c9"
  value         = outputs.vpc.value
}

input "us_east_1_public_vpc" {
  backend       = "default"
  from_stack_id = "dbd8d143-fc60-4676-bb24-2d5417cfeb47"
  value         = outputs.vpc.value
}

input "us_east_1_private_vpc" {
  backend       = "default"
  from_stack_id = "bc8d3cc0-6484-438d-8008-65a380858097"
  value         = outputs.vpc.value
}


input "us_east_2_public_vpc" {
  backend       = "default"
  from_stack_id = "87165042-56b8-4286-bf68-616866cc6256"
  value         = outputs.vpc.value
}

input "us_east_2_private_vpc" {
  backend       = "default"
  from_stack_id = "df397296-befc-4e60-8eb5-48c2af654b93"
  value         = outputs.vpc.value
}
