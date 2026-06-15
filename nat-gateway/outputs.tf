output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat_gateway.id
}

output "nat_gateway_public_ip" {
  description = "Public Elastic IP address associated with the NAT Gateway"
  value       = aws_nat_gateway.nat_gateway.public_ip
}

output "nat_gateway_private_ip" {
  description = "Private IP address of the NAT Gateway"
  value       = aws_nat_gateway.nat_gateway.private_ip
}

output "nat_gateway_network_interface_id" {
  description = "Network interface ID associated with the NAT Gateway"
  value       = aws_nat_gateway.nat_gateway.network_interface_id
}

output "eip_id" {
  description = "Allocation ID of the created Elastic IP (null if create_eip is false)"
  value       = length(aws_eip.nat_eip) > 0 ? aws_eip.nat_eip[0].id : null
}

output "eip_public_ip" {
  description = "Public IP of the created Elastic IP (null if create_eip is false)"
  value       = length(aws_eip.nat_eip) > 0 ? aws_eip.nat_eip[0].public_ip : null
}
