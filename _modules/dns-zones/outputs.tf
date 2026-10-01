output "zone_id" {
  description = "The ID of the hosted zone."
  value       = aws_route53_zone.this.zone_id
}

output "name" {
  description = "The name of the hosted zone, including the trailing dot."
  value       = aws_route53_zone.this.name
}

output "name_servers" {
  description = "The name servers assigned to the hosted zone by Route53."
  value       = aws_route53_zone.this.name_servers
}

output "arn" {
  description = "The ARN of the hosted zone."
  value       = aws_route53_zone.this.arn
}