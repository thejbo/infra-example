variable "domain" {
  description = "The fully qualified domain name to request the certificate for (eg: `example.com`)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?(\\.[a-z0-9]([a-z0-9-]*[a-z0-9])?)+$", var.domain))
    error_message = "The domain must be a lowercase fully qualified domain name without a scheme or trailing dot (eg: `example.com`)."
  }
}

variable "include_wildcard" {
  description = "Whether to add a wildcard subject alternative name for `domain` (eg: `*.example.com`)."
  type        = bool
  default     = true
}

variable "subject_alternative_names" {
  description = "Additional subject alternative names to add to the certificate. Each entry must be a subdomain of `domain`."
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.subject_alternative_names) == length(distinct(var.subject_alternative_names))
    error_message = "subject_alternative_names cannot contain duplicate entries."
  }

  validation {
    condition     = alltrue([for name in var.subject_alternative_names : endswith(name, ".${var.domain}")])
    error_message = "Each entry in subject_alternative_names must be a subdomain of domain (eg: `www.example.com`)."
  }
}

variable "validation_record_ttl" {
  description = "The TTL in seconds used for the Route53 DNS validation records."
  type        = number
  default     = 300

  validation {
    condition     = var.validation_record_ttl >= 0
    error_message = "validation_record_ttl must be greater than or equal to 0."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the certificate."
  type        = map(string)
  default     = {}
}