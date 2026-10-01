locals {
  tags = merge(
    var.tags,
    { "Name" = "zone-${var.domain}" },
  )
}

resource "aws_route53_zone" "this" {
  comment       = var.comment
  force_destroy = var.force_destroy
  name          = var.domain

  tags = local.tags
}