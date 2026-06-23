output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

output "internet_gateway_owner_id" {
  description = "AWS account ID that owns the Internet Gateway"
  value       = aws_internet_gateway.igw.owner_id
}
