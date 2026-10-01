output "distribution_id" {
  description = "The ID of the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.id
}

output "distribution_arn" {
  description = "The ARN of the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.arn
}

output "domain_name" {
  description = "The CloudFront domain name of the distribution."
  value       = aws_cloudfront_distribution.this.domain_name
}

output "hosted_zone_id" {
  description = "The Route 53 hosted zone ID used for CloudFront alias records."
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}

output "aliases" {
  description = "The CNAME aliases served by the distribution, including the primary domain name."
  value       = aws_cloudfront_distribution.this.aliases
}

output "status" {
  description = "The deployment status of the CloudFront distribution."
  value       = aws_cloudfront_distribution.this.status
}

output "origin_access_control_id" {
  description = "The ID of the origin access control, or null when `origin_access_control_enabled` is false."
  value       = local.origin_access_control_id
}