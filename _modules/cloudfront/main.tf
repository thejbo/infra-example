locals {
  comment                    = var.comment != null ? var.comment : "${var.domain_name} distribution"
  default_origin_id          = var.default_origin_id != null ? var.default_origin_id : keys(var.origins)[0]
  origin_access_control_id   = var.origin_access_control_enabled ? aws_cloudfront_origin_access_control.this.id : null
  origin_access_control_name = var.origin_access_control_name != null ? var.origin_access_control_name : "OAC-${var.domain_name}"

  origins = { for id, origin in var.origins : id => merge(origin, {
    origin_access_control_id = origin.origin_access_control_id != null ? origin.origin_access_control_id : local.origin_access_control_id
  }) }
}

resource "aws_cloudfront_distribution" "this" {

  aliases             = concat([var.domain_name], var.aliases)
  comment             = local.comment
  default_root_object = var.default_root_object
  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  price_class         = var.price_class
  wait_for_deployment = var.wait_for_deployment

  dynamic "origin" {
    for_each = local.origins

    content {
      domain_name              = origin.value.domain_name
      origin_id                = origin.key
      origin_access_control_id = origin.value.origin_access_control_id

      dynamic "custom_origin_config" {
        for_each = origin.value.custom_origin_config != null ? [origin.value.custom_origin_config] : []

        content {
          http_port              = custom_origin_config.value.http_port
          https_port             = custom_origin_config.value.https_port
          origin_protocol_policy = custom_origin_config.value.origin_protocol_policy
          origin_ssl_protocols   = custom_origin_config.value.origin_ssl_protocols
        }
      }

      dynamic "s3_origin_config" {
        for_each = origin.value.s3_origin_config != null ? [origin.value.s3_origin_config] : []

        content {
          origin_access_identity = s3_origin_config.value.origin_access_identity
        }
      }
    }
  }

  default_cache_behavior {
    allowed_methods          = var.allowed_methods
    cached_methods           = ["GET", "HEAD"]
    cache_policy_id          = var.cache_policy_id
    compress                 = var.compress
    default_ttl              = var.default_ttl
    max_ttl                  = var.max_ttl
    min_ttl                  = var.min_ttl
    origin_request_policy_id = var.origin_request_policy_id
    target_origin_id         = local.default_origin_id
    viewer_protocol_policy   = var.viewer_protocol_policy

    dynamic "forwarded_values" {
      for_each = var.cache_policy_id == null ? [true] : []

      content {
        query_string = var.forward_query_strings

        cookies {
          forward = var.cookies_forward
        }
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_type == "none" ? null : var.geo_restriction_locations
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    minimum_protocol_version = var.minimum_protocol_version
    ssl_support_method       = var.ssl_support_method
  }

  tags = merge(
    var.tags,
    { "Name" = local.comment },
  )

  lifecycle {
    create_before_destroy = true

    precondition {
      condition     = var.default_origin_id == null || contains(keys(var.origins), var.default_origin_id)
      error_message = "default_origin_id must be one of the keys of origins."
    }

    precondition {
      condition     = var.min_ttl <= var.default_ttl && var.default_ttl <= var.max_ttl
      error_message = "default_ttl must be greater than or equal to min_ttl and less than or equal to max_ttl."
    }

    precondition {
      condition     = var.min_ttl <= var.max_ttl
      error_message = "min_ttl must be less than or equal to max_ttl."
    }

    precondition {
      condition     = var.geo_restriction_type == "none" || length(var.geo_restriction_locations) > 0
      error_message = "geo_restriction_locations cannot be empty when geo_restriction_type is not none."
    }

    precondition {
      condition     = length(setintersection(var.allowed_methods, ["GET", "HEAD"])) == length(["GET", "HEAD"])
      error_message = "allowed_methods must include both GET and HEAD."
    }
  }
}

resource "aws_cloudfront_origin_access_control" "this" {

  name                              = local.origin_access_control_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"

  lifecycle {
    enabled = var.origin_access_control_enabled
  }
}