output "record_name" {
  description = "FQDN of the Route53 record"
  value       = aws_route53_record.record.fqdn
}

output "record_type" {
  description = "Type of the Route53 record"
  value       = aws_route53_record.record.type
}