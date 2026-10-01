output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.this.id
}

output "arn" {
  description = "The ARN of the VPC."
  value       = aws_vpc.this.arn
}

output "cidr_block" {
  description = "The CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "default_security_group_id" {
  description = "The ID of the default security group of the VPC."
  value       = aws_vpc.this.default_security_group_id
}

output "main_route_table_id" {
  description = "The ID of the main route table of the VPC."
  value       = aws_vpc.this.main_route_table_id
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway. Null when `internet_gw_enabled` is false."
  value       = try(aws_internet_gateway.this.id, null)
}

output "s3_endpoint_id" {
  description = "The ID of the S3 VPC endpoint. Null when `s3_endpoint_enabled` is false."
  value       = try(aws_vpc_endpoint.s3.id, null)
}

output "subnet_ids" {
  description = "A map of availability zone suffix to subnet ID."
  value       = { for suffix, subnet in aws_subnet.this : suffix => subnet.id }
}

output "subnet_cidrs" {
  description = "A map of availability zone suffix to subnet CIDR block."
  value       = { for suffix, subnet in aws_subnet.this : suffix => subnet.cidr_block }
}

output "subnet_availability_zones" {
  description = "A map of availability zone suffix to availability zone name."
  value       = { for suffix, subnet in aws_subnet.this : suffix => subnet.availability_zone }
}