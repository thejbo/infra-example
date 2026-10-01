variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate in us-east-1 for the distribution."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:acm:us-east-1:", var.acm_certificate_arn))
    error_message = "The ACM certificate must be in us-east-1, e.g. arn:aws:acm:us-east-1:123456789012:certificate/00000000-0000-0000-0000-000000000000."
  }
}

variable "domain_name" {
  description = "Primary domain name for the distribution. Added to aliases automatically."
  type        = string
}

variable "origins" {
  description = <<-EOT
    Map of origin ID to origin configuration. The map key is used as the
    `origin_id` of the CloudFront origin, so it cannot be changed without
    replacing the origin.

    An origin matches exactly one of the following CloudFront origin types:

    - S3 website endpoint: no config block, plus either `origin_access_control_id`
      or this module's `origin_access_control_enabled = true`
    - S3 REST endpoint: `s3_origin_config`
    - Custom origin (ALB, ECS, EC2, ...): `custom_origin_config`
  EOT
  type = map(object({
    domain_name              = string
    origin_access_control_id = optional(string)
    s3_origin_config = optional(object({
      origin_access_identity = string
    }))
    custom_origin_config = optional(object({
      http_port              = number
      https_port             = number
      origin_protocol_policy = string
      origin_ssl_protocols   = list(string)
    }))
  }))

  validation {
    condition     = length(var.origins) > 0
    error_message = "At least one origin must be defined."
  }

  validation {
    condition     = alltrue([for id, origin in var.origins : id != "" && origin.domain_name != ""])
    error_message = "Origin IDs and domain names cannot be empty."
  }

  validation {
    condition = alltrue([
      for id, origin in var.origins :
      !(origin.custom_origin_config != null && origin.s3_origin_config != null)
    ])
    error_message = "An origin cannot define both custom_origin_config and s3_origin_config."
  }

  validation {
    condition = alltrue([
      for id, origin in var.origins :
      origin.origin_access_control_id == null || origin.custom_origin_config == null
    ])
    error_message = "origin_access_control_id is only supported on S3 origins and cannot be combined with custom_origin_config."
  }
}

variable "default_origin_id" {
  description = "Origin ID for the default cache behavior. Defaults to the first key of `origins`."
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "aliases" {
  description = "Additional CNAME aliases for the distribution. `domain_name` is added automatically."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.aliases) == length(distinct(var.aliases))
    error_message = "aliases cannot contain duplicate entries."
  }
}

variable "allowed_methods" {
  description = "HTTP methods the viewer is allowed to use for the default cache behavior."
  type        = list(string)
  default     = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]

  validation {
    condition = alltrue([
      for method in var.allowed_methods :
      contains(["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"], method)
    ])
    error_message = "allowed_methods may only contain DELETE, GET, HEAD, OPTIONS, PATCH, POST and PUT."
  }
}

variable "cache_policy_id" {
  description = "ID of the cache policy for the default cache behavior. Leave null to use `forwarded_values` instead."
  type        = string
  default     = null

  validation {
    condition     = var.cache_policy_id == null || length(trimspace(var.cache_policy_id)) > 0
    error_message = "cache_policy_id cannot be empty when set."
  }
}

variable "comment" {
  description = "The comment for the distribution. Defaults to '<domain_name> distribution'."
  type        = string
  default     = null
}

variable "compress" {
  description = "Whether CloudFront automatically compresses responses for the default cache behavior."
  type        = bool
  default     = true
}

variable "cookies_forward" {
  description = "Which cookies to forward in `forwarded_values`. Ignored when `cache_policy_id` is set."
  type        = string
  default     = "none"

  validation {
    condition     = contains(["none", "all", "whitelist"], var.cookies_forward)
    error_message = "cookies_forward must be one of none, all or whitelist."
  }
}

variable "default_root_object" {
  description = "The default root object for the distribution."
  type        = string
  default     = "index.html"
}

variable "default_ttl" {
  description = "Default TTL in seconds for the default cache behavior. Requires `min_ttl` <= `default_ttl` <= `max_ttl`."
  type        = number
  default     = 3600
}

variable "enabled" {
  description = "Whether the distribution is enabled."
  type        = bool
  default     = true
}

variable "forward_query_strings" {
  description = "Whether to forward query strings in `forwarded_values`. Ignored when `cache_policy_id` is set."
  type        = bool
  default     = false
}

variable "geo_restriction_locations" {
  description = "List of ISO 3166-1 alpha-2 country codes to restrict the distribution to."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for location in var.geo_restriction_locations : can(regex("^[A-Z]{2}$", location))
    ])
    error_message = "geo_restriction_locations must be two letter uppercase ISO 3166-1 alpha-2 country codes."
  }
}

variable "geo_restriction_type" {
  description = "The geo restriction type for the distribution."
  type        = string
  default     = "none"

  validation {
    condition     = contains(["blacklist", "whitelist", "none"], var.geo_restriction_type)
    error_message = "geo_restriction_type must be one of blacklist, whitelist or none."
  }
}

variable "is_ipv6_enabled" {
  description = "Whether IPv6 is enabled for the distribution."
  type        = bool
  default     = true
}

variable "max_ttl" {
  description = "Maximum TTL in seconds for the default cache behavior. Requires `min_ttl` <= `max_ttl`."
  type        = number
  default     = 86400
}

variable "min_ttl" {
  description = "Minimum TTL in seconds for the default cache behavior."
  type        = number
  default     = 0

  validation {
    condition     = var.min_ttl >= 0
    error_message = "min_ttl must be greater than or equal to 0."
  }
}

variable "minimum_protocol_version" {
  description = "The minimum TLS protocol version for the viewer certificate."
  type        = string
  default     = "TLSv1.2_2021"

  validation {
    condition = contains([
      "TLSv1",
      "TLSv1_2016",
      "TLSv1.1_2016",
      "TLSv1.2_2018",
      "TLSv1.2_2019",
      "TLSv1.2_2021",
    ], var.minimum_protocol_version)
    error_message = "minimum_protocol_version must be a TLS policy CloudFront supports."
  }
}

variable "origin_access_control_enabled" {
  description = "Whether to create an origin access control and use it for any S3 origin that does not define `origin_access_control_id`."
  type        = bool
  default     = false
}

variable "origin_access_control_name" {
  description = "Name for the origin access control. Defaults to 'OAC-<domain_name>'."
  type        = string
  default     = null
}

variable "origin_request_policy_id" {
  description = "ID of the origin request policy for the default cache behavior. Leave null to forward nothing."
  type        = string
  default     = null

  validation {
    condition     = var.origin_request_policy_id == null || length(trimspace(var.origin_request_policy_id)) > 0
    error_message = "origin_request_policy_id cannot be empty when set."
  }
}

variable "price_class" {
  description = "The price class for the distribution."
  type        = string
  default     = "PriceClass_100"

  validation {
    condition     = contains(["PriceClass_All", "PriceClass_200", "PriceClass_100"], var.price_class)
    error_message = "price_class must be one of PriceClass_All, PriceClass_200 or PriceClass_100."
  }
}

variable "ssl_support_method" {
  description = "The SSL support method for the viewer certificate."
  type        = string
  default     = "sni-only"

  validation {
    condition     = contains(["sni-only", "vip"], var.ssl_support_method)
    error_message = "ssl_support_method must be one of sni-only or vip."
  }
}

variable "viewer_protocol_policy" {
  description = "The viewer protocol policy for the default cache behavior."
  type        = string
  default     = "redirect-to-https"

  validation {
    condition = contains([
      "allow-all",
      "https-only",
      "redirect-to-https",
    ], var.viewer_protocol_policy)
    error_message = "viewer_protocol_policy must be one of allow-all, https-only or redirect-to-https."
  }
}

variable "wait_for_deployment" {
  description = "Whether to wait for the distribution deployment to complete."
  type        = bool
  default     = false
}