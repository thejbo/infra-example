locals {
  s3_endpoint_service_name = "com.amazonaws.${var.region}.s3"

  tags = {
    vpc = merge(
      var.tags,
      { "Name" = "vpc-${var.name}" },
    )

    internet_gateway = merge(
      var.tags,
      { "Name" = "igw-${var.name}" },
    )

    subnets = {
      for key in keys(var.subnets) :
      key => merge(
        var.tags,
        { "Name" = "subnet-${var.name}-${key}" },
      )
    }

    s3_endpoint = merge(
      var.tags,
      { "Name" = "s3-endpoint-${var.name}" },
    )
  }
}

resource "aws_vpc" "this" {
  cidr_block                       = var.cidr
  assign_generated_ipv6_cidr_block = var.ipv6_cidr_block_enabled
  enable_dns_hostnames             = var.dns_hostnames_enabled
  enable_dns_support               = var.dns_support_enabled

  tags = local.tags.vpc
}
