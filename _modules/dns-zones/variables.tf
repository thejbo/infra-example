variable "domain" {
  description = "The fully qualified domain name of the hosted zone (eg: `example.com`)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]*[a-z0-9])?(\\.[a-z0-9]([a-z0-9-]*[a-z0-9])?)+$", var.domain))
    error_message = "The domain must be a lowercase fully qualified domain name without a scheme or trailing dot (eg: `example.com`)."
  }
}

variable "comment" {
  description = "The comment recorded on the hosted zone."
  type        = string
  default     = "Managed by OpenTofu"
}

variable "force_destroy" {
  description = "Whether to delete all records in the hosted zone when the zone is destroyed."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the hosted zone. A `Name` tag is always set to `zone-<domain>`."
  type        = map(string)
  default     = {}
}