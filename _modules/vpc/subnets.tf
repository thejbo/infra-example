resource "aws_subnet" "this" {
  for_each = var.subnets

  availability_zone       = "${var.region}${each.key}"
  cidr_block              = each.value
  map_public_ip_on_launch = var.map_public_ip
  vpc_id                  = aws_vpc.this.id

  tags = local.tags.subnets[each.key]
}