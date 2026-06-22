output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.certificate.arn
}

output "domain_name" {
  description = "Primary domain name of the ACM certificate"
  value       = aws_acm_certificate.certificate.domain_name
}

output "domain_validation_options" {
  description = "Domain validation options for DNS validation"
  value       = aws_acm_certificate.certificate.domain_validation_options
}