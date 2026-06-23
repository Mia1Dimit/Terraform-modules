output "subnet_id" {
  description = "ID of the subnet"
  value       = aws_subnet.subnet.id
}

output "subnet_arn" {
  description = "ARN of the subnet"
  value       = aws_subnet.subnet.arn
}

output "availability_zone" {
  description = "Availability Zone of the subnet"
  value       = aws_subnet.subnet.availability_zone
}

output "cidr_block" {
  description = "CIDR block of the subnet"
  value       = aws_subnet.subnet.cidr_block
}
