output "certificate_arn" {
  description = "The ARN of the ACM certificate."
  value       = aws_acm_certificate.this.arn
}

output "certificate_id" {
  description = "The ID of the ACM certificate."
  value       = aws_acm_certificate.this.id
}

output "certificate_domain_name" {
  description = "The primary domain name of the ACM certificate."
  value       = aws_acm_certificate.this.domain_name
}

output "certificate_status" {
  description = "The validation status of the ACM certificate."
  value       = aws_acm_certificate.this.status
}

output "validation_record_fqdns" {
  description = "The FQDNs of the Route53 records used to validate the certificate."
  value       = [for record in aws_route53_record.validation : record.fqdn]
}

output "zone_id" {
  description = "The ID of the Route53 hosted zone used to validate the certificate."
  value       = data.aws_route53_zone.this.zone_id
}