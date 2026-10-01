locals {
  subject_alternative_names = concat(
    [var.domain],
    var.include_wildcard ? ["*.${var.domain}"] : [],
    var.subject_alternative_names,
  )

  tags = merge(
    var.tags,
    { "Name" = "acm-${var.domain}" },
  )
}

resource "aws_acm_certificate" "this" {
  domain_name               = var.domain
  subject_alternative_names = local.subject_alternative_names
  validation_method         = "DNS"

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]

  lifecycle {
    create_before_destroy = true
  }
}