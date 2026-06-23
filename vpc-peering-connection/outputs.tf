output "peering_connection_id" {
  description = "ID of the VPC peering connection"
  value       = aws_vpc_peering_connection.peering.id
}

output "peering_connection_status" {
  description = "Status of the VPC peering connection"
  value       = aws_vpc_peering_connection.peering.accept_status
}

output "peering_connection_arn" {
  description = "ARN of the VPC peering connection"
  value       = aws_vpc_peering_connection.peering.id
}
