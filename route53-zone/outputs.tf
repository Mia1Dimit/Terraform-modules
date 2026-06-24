output "zone_id" {
  description = "ID of the Route53 hosted zone"
  value       = aws_route53_zone.zone.zone_id
}

output "zone_arn" {
  description = "ARN of the Route53 hosted zone"
  value       = aws_route53_zone.zone.arn
}

output "name_servers" {
  description = "Name servers for the hosted zone"
  value       = aws_route53_zone.zone.name_servers
}

output "primary_name_server" {
  description = "Primary name server for the hosted zone"
  value       = aws_route53_zone.zone.primary_name_server
}
