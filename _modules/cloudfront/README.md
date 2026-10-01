# CloudFront Module

Creates a CloudFront distribution, with an optional origin access control for S3 origins.

## Features

- Creates a distribution from a map of origins (S3 website endpoint, S3 REST endpoint or custom origin)
- Optionally creates an origin access control and wires it into every S3 origin that does not bring its own
- Cache behaviour configurable with either a managed cache policy or legacy `forwarded_values`
- Configurable TTLs, geo restriction, viewer certificate and viewer protocol policy
- Validates enum-style inputs and TTL ordering
- Tags the distribution with a `Name` derived from `domain_name`

## Requirements

| Name      | Version  |
| --------- | -------- |
| opentofu  | >= 1.11  |
| aws       | >= 6.0   |

The `enabled` meta-argument requires OpenTofu 1.11 or newer.

## Usage

S3 website endpoint with an origin access control:

```hcl
module "cloudfront" {
  source = "${var.module_root}/cloudfront"

  domain_name                 = "example.com"
  acm_certificate_arn         = "arn:aws:acm:us-east-1:123456789012:certificate/abc-123"
  origin_access_control_enabled = true

  origins = {
    s3 = {
      domain_name = "my-bucket.s3.us-west-2.amazonaws.com"
    }
  }

  tags = var.tags
}
```

Custom origin (ALB, ECS, EC2) using a managed cache policy:

```hcl
module "cloudfront" {
  source = "${var.module_root}/cloudfront"

  domain_name         = "app.example.com"
  acm_certificate_arn = local.us_east_1_acm_certs["app.example.com"].cert.arn
  aliases             = ["www.app.example.com"]

  origins = {
    alb = {
      domain_name = "internal-app-lb-1234.us-west-2.elb.amazonaws.com"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }
    legacy = {
      domain_name = "legacy-origin.example.com"
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "http-only"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }
    }
  }

  default_origin_id = "alb"

  cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6" # CachingOptimized
  origin_request_policy_id = "33f36d7e-f396-46d9-90e0-52428a34d9dc" # AllViewerExceptHostHeader

  tags = var.tags
}
```

### Route 53 records

CloudFront alias records use a fixed hosted zone ID:

```hcl
resource "aws_route53_record" "apex" {
  zone_id = local.dns_zones["example.com"].zone_id
  name    = "example.com"
  type    = "A"

  alias {
    name                   = module.cloudfront.domain_name
    zone_id                = module.cloudfront.hosted_zone_id # Z2FDTNDATAQYW2
    evaluate_target_health = false
  }
}
```

## Variables

| Variable                            | Type          | Default                    | Description                                                                                                    |
| ----------------------------------- | ------------- | -------------------------- | -------------------------------------------------------------------------------------------------------------- |
| `acm_certificate_arn`               | string        | -                          | ARN of the ACM certificate in us-east-1 for the distribution. Must be in us-east-1.                             |
| `domain_name`                       | string        | -                          | Primary domain name for the distribution. Added to aliases automatically.                                       |
| `origins`                           | map(object)   | -                          | Map of origin ID to origin configuration. The key is used as the CloudFront `origin_id`.                       |
| `default_origin_id`                 | string        | `null`                     | Origin ID for the default cache behavior. Defaults to the first key of `origins`.                               |
| `tags`                              | map(string)   | `{}`                       | A mapping of tags to assign to the distribution.                                                                |
| `aliases`                           | list(string)  | `[]`                       | Additional CNAME aliases for the distribution. `domain_name` is added automatically.                            |
| `allowed_methods`                   | list(string)  | all seven methods          | HTTP methods the viewer is allowed to use for the default cache behavior. Must include `GET` and `HEAD`.        |
| `cache_policy_id`                   | string        | `null`                     | ID of the cache policy for the default cache behavior. Leave null to use `forwarded_values` instead.            |
| `comment`                           | string        | `null`                     | The comment for the distribution. Defaults to '<domain_name> distribution'.                                      |
| `compress`                          | bool          | `true`                     | Whether CloudFront automatically compresses responses.                                                          |
| `cookies_forward`                   | string        | `"none"`                   | Which cookies to forward in `forwarded_values`. Ignored when `cache_policy_id` is set.                         |
| `default_root_object`               | string        | `"index.html"`             | The default root object for the distribution.                                                                  |
| `default_ttl`                       | number        | `3600`                     | Default TTL in seconds. Requires `min_ttl` <= `default_ttl` <= `max_ttl`.                                       |
| `enabled`                           | bool          | `true`                     | Whether the distribution is enabled.                                                                           |
| `forward_query_strings`             | bool          | `false`                    | Whether to forward query strings in `forwarded_values`. Ignored when `cache_policy_id` is set.                 |
| `geo_restriction_locations`         | list(string)  | `[]`                       | List of ISO 3166-1 alpha-2 country codes to restrict the distribution to.                                       |
| `geo_restriction_type`              | string        | `"none"`                   | One of `blacklist`, `whitelist` or `none`. Requires locations when not `none`.                                 |
| `is_ipv6_enabled`                   | bool          | `true`                     | Whether IPv6 is enabled for the distribution.                                                                  |
| `max_ttl`                           | number        | `86400`                    | Maximum TTL in seconds. Requires `min_ttl` <= `max_ttl`.                                                       |
| `min_ttl`                           | number        | `0`                        | Minimum TTL in seconds.                                                                                         |
| `minimum_protocol_version`          | string        | `"TLSv1.2_2021"`           | The minimum TLS protocol version for the viewer certificate.                                                   |
| `origin_access_control_enabled`     | bool          | `false`                    | Whether to create an origin access control and use it for any S3 origin without an `origin_access_control_id`.  |
| `origin_access_control_name`        | string        | `null`                     | Name for the origin access control. Defaults to 'OAC-<domain_name>'.                                          |
| `origin_request_policy_id`          | string        | `null`                     | ID of the origin request policy for the default cache behavior.                                                 |
| `price_class`                       | string        | `"PriceClass_100"`         | One of `PriceClass_All`, `PriceClass_200` or `PriceClass_100`.                                                |
| `ssl_support_method`                | string        | `"sni-only"`               | One of `sni-only` or `vip`.                                                                                    |
| `viewer_protocol_policy`            | string        | `"redirect-to-https"`      | One of `allow-all`, `https-only` or `redirect-to-https`.                                                       |
| `wait_for_deployment`               | bool          | `false`                    | Whether to wait for the distribution deployment to complete.                                                   |

### `origins` schema

| Attribute                   | Type   | Description                                                                                                    |
| --------------------------- | ------ | -------------------------------------------------------------------------------------------------------------- |
| `domain_name`               | string | Required. Origin domain name, e.g. `my-bucket.s3.us-west-2.amazonaws.com` or an ELB hostname.                  |
| `origin_access_control_id`  | string | Optional. S3 origins only. Defaults to the module's origin access control when `origin_access_control_enabled`. Cannot be combined with `custom_origin_config`. |
| `s3_origin_config`          | object | Optional. For S3 REST endpoints. Requires `origin_access_identity`.                                            |
| `custom_origin_config`      | object | Optional. For custom origins. Requires `http_port`, `https_port`, `origin_protocol_policy` and `origin_ssl_protocols`. |

## Outputs

| Output                      | Type        | Description                                                                    |
| --------------------------- | ----------- | ------------------------------------------------------------------------------ |
| `distribution_id`           | string      | The ID of the CloudFront distribution.                                          |
| `distribution_arn`          | string      | The ARN of the CloudFront distribution.                                         |
| `domain_name`               | string      | The CloudFront domain name of the distribution.                                  |
| `hosted_zone_id`            | string      | The Route 53 hosted zone ID used for CloudFront alias records.                   |
| `aliases`                   | list(string) | The CNAME aliases served by the distribution, including the primary domain name. |
| `status`                    | string      | The deployment status of the CloudFront distribution.                            |
| `origin_access_control_id`  | string      | The origin access control ID, or null when `origin_access_control_enabled` is false. |

## Notes

- `aws_cloudfront_origin_access_control` does not support tags, so only the distribution is tagged.
- The default cache behaviour uses `forwarded_values` unless `cache_policy_id` is set. The two are mutually exclusive in CloudFront, so `forwarded_values` is omitted when a cache policy is used.
- Changing an origin's `origin_id` replaces that origin, which deploys a new CloudFront distribution and switches traffic.