variable "name" {
  description = "The name used as a prefix for the VPC and all of its resources (eg: `virginia-public`)."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "The name must only contain lowercase letters, numbers, and dashes."
  }
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  type        = string

  validation {
    condition     = can(cidrhost(var.cidr, 0))
    error_message = "The cidr must be a valid CIDR block."
  }
}

variable "region" {
  description = "The AWS region the VPC is created in. It is also used to build the availability zone names of the subnets."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z0-9-]+-[0-9]+$", var.region))
    error_message = "The region must be a valid AWS region name (eg: `us-east-1`)."
  }
}

variable "subnets" {
  description = "A map of availability zone suffixes to CIDR blocks (eg: `{ a = \"10.0.0.0/24\" }`). Each key is appended to `var.region` to build the availability zone name of the subnet."
  type        = map(string)

  validation {
    condition     = alltrue([for suffix in keys(var.subnets) : can(regex("^[a-z]$", suffix))])
    error_message = "Each subnet key must be a single lowercase letter used as an availability zone suffix."
  }

  validation {
    condition     = alltrue([for cidr in values(var.subnets) : can(cidrhost(cidr, 0))])
    error_message = "Each subnet value must be a valid CIDR block."
  }
}

variable "map_public_ip" {
  description = "(Optional) Whether to automatically assign public IP addresses to the subnets."
  type        = bool
  default     = true
}

variable "internet_gw_enabled" {
  description = "(Optional) Whether to create an internet gateway and a default `0.0.0.0/0` route in the main route table."
  type        = bool
  default     = true
}

variable "s3_endpoint_enabled" {
  description = "(Optional) Whether to create a gateway endpoint for S3 and associate it with the main route table."
  type        = bool
  default     = true
}

variable "dns_support_enabled" {
  description = "(Optional) Whether the VPC supports DNS resolution. Must be enabled for `dns_hostnames_enabled` to have any effect."
  type        = bool
  default     = true
}

variable "dns_hostnames_enabled" {
  description = "(Optional) Whether instances launched in the VPC receive public DNS hostnames."
  type        = bool
  default     = true
}

variable "ipv6_cidr_block_enabled" {
  description = "(Optional) Whether an Amazon provided IPv6 CIDR block is assigned to the VPC."
  type        = bool
  default     = true
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}