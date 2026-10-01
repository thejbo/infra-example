locals {
  vpcs = {
    public = {
      us-west-2 = var.us_west_2_public_vpc
      us-east-1 = var.us_east_1_public_vpc
      us-east-2 = var.us_east_2_public_vpc
    }
    private = {
      us-west-2 = var.us_west_2_private_vpc
      us-east-1 = var.us_east_1_private_vpc
      us-east-2 = var.us_east_2_private_vpc
    }
  }
}
resource "aws_vpc_peering_connection" "us-west-2_us-east-2" {
  region   = "us-west-2"
  for_each = local.vpcs

  peer_owner_id = local.account.number
  peer_vpc_id   = local.vpcs[each.key]["us-east-2"].vpc_id
  vpc_id        = local.vpcs[each.key]["us-west-2"].vpc_id
  peer_region   = "us-east-2"
  auto_accept   = false

  tags = merge(
    local.scope,
    { vpc = each.key },
    { "Name" = "${lower(local.regions.us-west-2)} <-> ${lower(local.regions.us-east-2)}" },
  )
}

resource "aws_vpc_peering_connection" "us-west-2_us-east-1" {
  region   = "us-west-2"
  for_each = local.vpcs

  peer_owner_id = local.account.number
  peer_vpc_id   = local.vpcs[each.key]["us-east-1"].vpc_id
  vpc_id        = local.vpcs[each.key]["us-west-2"].vpc_id
  peer_region   = "us-east-1"
  auto_accept   = false

  tags = merge(
    local.scope,
    { vpc = each.key },
    { Name = "${lower(local.regions.us-west-2)} <-> ${lower(local.regions.us-east-1)}" },
  )
}

## Route Tables
# Default Allow Egress/Ingress from both VPCs
resource "aws_route" "rtb_us-east-1-us-west-2" {
  region   = "us-east-1"
  for_each = local.vpcs

  route_table_id            = local.vpcs[each.key]["us-east-1"].main_route_table_id
  destination_cidr_block    = local.vpcs[each.key]["us-west-2"].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.us-west-2_us-east-1[each.key].id
}

resource "aws_route" "rtb_us-west-2-us-east-1" {
  region   = "us-west-2"
  for_each = local.vpcs

  route_table_id            = local.vpcs[each.key]["us-west-2"].main_route_table_id
  destination_cidr_block    = local.vpcs[each.key]["us-east-1"].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.us-west-2_us-east-1[each.key].id
}

resource "aws_route" "rtb_us-west-2-us-east-2" {
  region   = "us-west-2"
  for_each = local.vpcs

  route_table_id            = local.vpcs[each.key]["us-west-2"].main_route_table_id
  destination_cidr_block    = local.vpcs[each.key]["us-east-2"].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.us-west-2_us-east-2[each.key].id
}

resource "aws_route" "rtb_us-east-2-us-west-2" {
  region   = "us-east-2"
  for_each = local.vpcs

  route_table_id            = local.vpcs[each.key]["us-east-2"].main_route_table_id
  destination_cidr_block    = local.vpcs[each.key]["us-west-2"].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.us-west-2_us-east-2[each.key].id
}

## default Security Groups
resource "aws_security_group_rule" "sg_us-east-1" {
  for_each = local.vpcs

  region            = "us-east-1"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = [local.vpcs[each.key]["us-west-2"].cidr_block]
  security_group_id = local.vpcs[each.key]["us-east-1"].default_security_group_id
}

resource "aws_security_group_rule" "sg_us-west-2" {
  for_each = local.vpcs

  region            = "us-west-2"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = [local.vpcs[each.key]["us-east-2"].cidr_block]
  security_group_id = local.vpcs[each.key]["us-west-2"].default_security_group_id
}

resource "aws_security_group_rule" "sg_us-east-2" {
  for_each = local.vpcs

  region            = "us-east-2"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  cidr_blocks       = [local.vpcs[each.key]["us-west-2"].cidr_block]
  security_group_id = local.vpcs[each.key]["us-east-2"].default_security_group_id
}
