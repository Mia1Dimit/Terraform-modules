output "vpc_endpoint_id" {
  description = "ID of the VPC endpoint"
  value       = aws_vpc_endpoint.vpc_endpoint.id
}

output "vpc_endpoint_arn" {
  description = "ARN of the VPC endpoint"
  value       = aws_vpc_endpoint.vpc_endpoint.arn
}

output "vpc_endpoint_state" {
  description = "Current state of the VPC endpoint"
  value       = aws_vpc_endpoint.vpc_endpoint.state
}

output "network_interface_ids" {
  description = "Network interface IDs created for Interface endpoints"
  value       = aws_vpc_endpoint.vpc_endpoint.network_interface_ids
}

output "dns_entry" {
  description = "DNS entries for Interface endpoints"
  value       = aws_vpc_endpoint.vpc_endpoint.dns_entry
}
