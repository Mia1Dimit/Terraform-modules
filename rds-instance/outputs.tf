output "db_instance_id" {
  description = "RDS DBI resource ID"
  value       = aws_db_instance.db_instance.id
}

output "db_instance_arn" {
  description = "ARN of the RDS instance"
  value       = aws_db_instance.db_instance.arn
}

output "db_instance_identifier" {
  description = "Identifier of the RDS instance"
  value       = aws_db_instance.db_instance.identifier
}

output "db_instance_address" {
  description = "Hostname of the RDS instance"
  value       = aws_db_instance.db_instance.address
}

output "db_instance_port" {
  description = "Port the database is listening on"
  value       = aws_db_instance.db_instance.port
}

output "db_instance_endpoint" {
  description = "Connection endpoint in address:port format"
  value       = aws_db_instance.db_instance.endpoint
}

output "db_instance_engine_version_actual" {
  description = "Running engine version (may differ from requested due to auto-upgrade)"
  value       = aws_db_instance.db_instance.engine_version_actual
}

output "db_subnet_group_id" {
  description = "ID of the DB subnet group (null if not created by this module)"
  value       = length(aws_db_subnet_group.db_subnet_group) > 0 ? aws_db_subnet_group.db_subnet_group[0].id : null
}

output "db_subnet_group_arn" {
  description = "ARN of the DB subnet group (null if not created by this module)"
  value       = length(aws_db_subnet_group.db_subnet_group) > 0 ? aws_db_subnet_group.db_subnet_group[0].arn : null
}
