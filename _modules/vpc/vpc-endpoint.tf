resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.this.id
  service_name = local.s3_endpoint_service_name

  tags = local.tags.s3_endpoint

  lifecycle {
    enabled = var.s3_endpoint_enabled
  }
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  route_table_id  = aws_vpc.this.main_route_table_id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id

  lifecycle {
    enabled = var.s3_endpoint_enabled
  }
}