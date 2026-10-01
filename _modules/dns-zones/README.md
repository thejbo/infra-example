# DNS Zones Module

Creates Route53 hosted zones for one or more domains.

## Requirements

- AWS provider `~> 6.0`

## Usage

Single zone:

```hcl
module "dns_zones" {
  source = "${var.module_root}/dns-zones"

  domain = "example.com"
  tags   = local.scope
}
```

One zone per domain, keyed by domain:

```hcl
module "dns_zones" {
  source   = "${var.module_root}/dns-zones"
  for_each = local.account.dns_zones

  domain = each.key
  tags   = local.scope
}
```

Consuming the zone ID on a record:

```hcl
resource "aws_route53_record" "this" {
  zone_id = module.dns_zones["example.com"].zone_id
  name    = "example.com"
  type    = "A"

  records = ["192.0.2.1"]
  ttl     = 300
}
```

## Variables

| Variable        | Type          | Default              | Description                                                                                     |
| --------------- | ------------- | -------------------- | ----------------------------------------------------------------------------------------------- |
| `domain`        | `string`      | n/a                  | The fully qualified domain name of the hosted zone (eg: `example.com`).                          |
| `comment`       | `string`      | `"Managed by OpenTofu"` | The comment recorded on the hosted zone.                                                        |
| `force_destroy` | `bool`        | `false`              | Whether to delete all records in the hosted zone when the zone is destroyed.                      |
| `tags`          | `map(string)` | `{}`                 | A mapping of tags to assign to the hosted zone. A `Name` tag is always set to `zone-<domain>`.     |

### Validations

- `domain` must be a lowercase fully qualified domain name with no scheme and no
  trailing dot.

## Outputs

| Output         | Type     | Description                                                      |
| -------------- | -------- | ---------------------------------------------------------------- |
| `zone_id`      | `string` | The ID of the hosted zone.                                        |
| `name`         | `string` | The name of the hosted zone, including the trailing dot.         |
| `name_servers` | `list(string)` | The name servers assigned to the hosted zone by Route53.    |
| `arn`          | `string` | The ARN of the hosted zone.                                       |

## Notes

- `force_destroy` defaults to `false`, so Route53 refuses to destroy a zone that
  still has records. Set it to `true` only for disposable zones, such as
  sandboxes that are torn down and recreated regularly.