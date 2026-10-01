# VPC Module

Creates a VPC with subnets, an optional internet gateway, and an S3 gateway endpoint.

## Features

- Creates a VPC with DNS support and an Amazon provided IPv6 CIDR block
- Creates one subnet per availability zone from a single map of CIDR blocks
- Conditionally creates an internet gateway with a default `0.0.0.0/0` route
- Conditionally creates an S3 gateway endpoint associated with the main route table
- Applies consistent `Name` tags to every resource

## Usage

Public VPC with an internet gateway:

```hcl
module "vpc" {
  source = "${var.module_root}/vpc"

  name    = lower("${local.regions[local.scope.region]}-${local.scope.vpc}")
  cidr    = local.networks[local.scope.account][local.scope.region][local.scope.vpc].cidr
  region  = local.scope.region
  subnets = local.networks[local.scope.account][local.scope.region][local.scope.vpc].zones
  tags    = local.scope
}
```

Private VPC without an internet gateway, and without the S3 endpoint:

```hcl
module "vpc" {
  source = "${var.module_root}/vpc"

  name                = lower("${local.regions[local.scope.region]}-${local.scope.vpc}")
  cidr                = local.networks[local.scope.account][local.scope.region][local.scope.vpc].cidr
  region              = local.scope.region
  subnets             = local.networks[local.scope.account][local.scope.region][local.scope.vpc].zones
  internet_gw_enabled = false
  s3_endpoint_enabled = false
  map_public_ip       = false
  tags                = local.scope
}
```

## Requirements

| Name    | Version |
| ------- | ------- |
| tofu    | >= 1.11 |

The `enabled` meta-argument requires OpenTofu 1.11 or later.

## Providers

| Name | Version |
| ---- | ------- |
| aws  | ~> 6.0  |

## Modules

No modules are used by this module.

## Resources

| Name                                          | Type                                       |
| --------------------------------------------- | ------------------------------------------ |
| aws_vpc.this                                  | aws_vpc                                    |
| aws_subnet.this                               | aws_subnet                                 |
| aws_internet_gateway.this                     | aws_internet_gateway                       |
| aws_route.default                             | aws_route                                  |
| aws_vpc_endpoint.s3                           | aws_vpc_endpoint                           |
| aws_vpc_endpoint_route_table_association.s3   | aws_vpc_endpoint_route_table_association   |

## Inputs

The following inputs are required:

| Name       | Type        | Default | Description                                                                                       |
| ---------- | ----------- | ------- | ------------------------------------------------------------------------------------------------- |
| `name`     | string      | n/a     | The name used as a prefix for the VPC and all of its resources (eg: `virginia-public`).             |
| `cidr`     | string      | n/a     | The CIDR block for the VPC.                                                                         |
| `region`   | string      | n/a     | The AWS region the VPC is created in. It is also used to build the availability zone names of the subnets. |
| `subnets`  | map(string) | n/a     | A map of availability zone suffixes to CIDR blocks. Each key is appended to `var.region` to build the availability zone name of the subnet. |

The following inputs are optional:

| Name                     | Type        | Default | Description                                                                                                |
| ------------------------ | ----------- | ------- | ------------------------------------------------------------------------------------------------------------ |
| `map_public_ip`          | bool        | `true`  | Whether to automatically assign public IP addresses to the subnets.                                          |
| `internet_gw_enabled`    | bool        | `true`  | Whether to create an internet gateway and a default `0.0.0.0/0` route in the main route table.               |
| `s3_endpoint_enabled`    | bool        | `true`  | Whether to create a gateway endpoint for S3 and associate it with the main route table.                      |
| `dns_support_enabled`    | bool        | `true`  | Whether the VPC supports DNS resolution. Must be enabled for `dns_hostnames_enabled` to have any effect.      |
| `dns_hostnames_enabled`  | bool        | `true`  | Whether instances launched in the VPC receive public DNS hostnames.                                          |
| `ipv6_cidr_block_enabled` | bool       | `true`  | Whether an Amazon provided IPv6 CIDR block is assigned to the VPC.                                           |
| `tags`                   | map(string) | `{}`    | A mapping of tags to assign to all resources.                                                               |

## Outputs

| Name                          | Type        | Description                                                            |
| ----------------------------- | ----------- | ---------------------------------------------------------------------- |
| `vpc_id`                      | string      | The ID of the VPC.                                                      |
| `arn`                         | string      | The ARN of the VPC.                                                     |
| `cidr_block`                  | string      | The CIDR block of the VPC.                                              |
| `default_security_group_id`   | string      | The ID of the default security group of the VPC.                       |
| `main_route_table_id`         | string      | The ID of the main route table of the VPC.                             |
| `internet_gateway_id`         | string      | The ID of the internet gateway. Null when `internet_gw_enabled` is false. |
| `s3_endpoint_id`              | string      | The ID of the S3 VPC endpoint. Null when `s3_endpoint_enabled` is false. |
| `subnet_ids`                  | map(string) | A map of availability zone suffix to subnet ID.                         |
| `subnet_cidrs`                | map(string) | A map of availability zone suffix to subnet CIDR block.                  |
| `subnet_availability_zones`   | map(string) | A map of availability zone suffix to availability zone name.             |