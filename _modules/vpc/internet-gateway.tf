resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = local.tags.internet_gateway

  lifecycle {
    enabled = var.internet_gw_enabled
  }
}