# ACM Certificates Module

Creates an AWS ACM certificate for a domain and validates it by writing the
required DNS validation records into the matching public Route53 hosted zone.

The module always requests the primary domain plus a wildcard for it
(`example.com` and `*.example.com`). Additional names can be added through
`subject_alternative_names`.

## Requirements

- AWS provider `~> 6.0`
- A Route53 public hosted zone already exists for `domain`. The zone is looked up
  by name, it is not created by this module. See the
  [`dns-zones`](../dns-zones) module for that.

## Usage

Single certificate:

```hcl
module "acm_certs" {
  source = "${var.module_root}/acm-certs"

  domain = "example.com"
  tags   = local.scope
}
```

One certificate per domain, keyed by domain:

```hcl
module "acm_certs" {
  source   = "${var.module_root}/acm-certs"
  for_each = toset(local.account.acm_certs)

  domain = each.key
  tags   = local.scope
}
```

Certificate without a wildcard, plus extra names:

```hcl
module "acm_certs" {
  source = "${var.module_root}/acm-certs"

  domain                    = "example.com"
  include_wildcard          = false
  subject_alternative_names = ["www.example.com", "api.example.com"]
  tags                      = local.scope
}
```

Consuming the ARN, for example on a CloudFront distribution:

```hcl
resource "aws_cloudfront_distribution" "this" {
  # ...

  viewer_certificate {
    acm_certificate_arn      = module.acm_certs["example.com"].certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}
```

## Variables

| Variable                   | Type           | Default | Description                                                                                                    |
| -------------------------- | -------------- | ------- | -------------------------------------------------------------------------------------------------------------- |
| `domain`                   | `string`       | n/a     | The fully qualified domain name to request the certificate for (eg: `example.com`).                             |
| `include_wildcard`         | `bool`         | `true`  | Whether to add a wildcard subject alternative name for `domain` (eg: `*.example.com`).                         |
| `subject_alternative_names` | `list(string)` | `[]`    | Additional subject alternative names. Each entry must be a subdomain of `domain`.                                |
| `validation_record_ttl`    | `number`       | `300`   | The TTL in seconds used for the Route53 DNS validation records.                                                 |
| `tags`                     | `map(string)`  | `{}`    | A mapping of tags to assign to the certificate. A `Name` tag is always set to `acm-<domain>`.                    |

### Validations

- `domain` must be a lowercase fully qualified domain name with no scheme and no trailing dot.
- `subject_alternative_names` must not contain duplicates.
- Each entry in `subject_alternative_names` must be a subdomain of `domain`.
- `validation_record_ttl` must be greater than or equal to `0`.

## Outputs

| Output                    | Type           | Description                                                              |
| ------------------------- | -------------- | ------------------------------------------------------------------------ |
| `certificate_arn`         | `string`       | The ARN of the ACM certificate.                                          |
| `certificate_id`          | `string`       | The ID of the ACM certificate.                                           |
| `certificate_domain_name` | `string`       | The primary domain name of the ACM certificate.                          |
| `certificate_status`      | `string`       | The validation status of the ACM certificate.                            |
| `validation_record_fqdns` | `list(string)` | The FQDNs of the Route53 records used to validate the certificate.        |
| `zone_id`                 | `string`       | The ID of the Route53 hosted zone used to validate the certificate.      |

## Resources created

| Resource                          | Notes                                                                     |
| --------------------------------- | ------------------------------------------------------------------------- |
| `aws_acm_certificate.this`        | `create_before_destroy` so a replacement certificate can reuse the DNS validation records. |
| `aws_route53_record.validation`   | One record per domain validation option. `allow_overwrite` is enabled so pre-existing records are adopted. |
| `aws_acm_certificate_validation.this` | Waits for all validation records to be in place before validating.       |

## Notes

- Validation is always `DNS`. Email validation is not supported, so `domain`
  must resolve in a public Route53 hosted zone.
- The validation records are read from the certificate's
  `domain_validation_options`, so any change to `domain`,
  `include_wildcard` or `subject_alternative_names` is handled without
  re-deriving record names locally.