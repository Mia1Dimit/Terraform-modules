output "replication_group_id" {
  description = "ID of the ElastiCache replication group"
  value       = aws_elasticache_replication_group.replication_group.id
}

output "replication_group_arn" {
  description = "ARN of the ElastiCache replication group"
  value       = aws_elasticache_replication_group.replication_group.arn
}

output "primary_endpoint_address" {
  description = "Primary endpoint address for the replication group"
  value       = aws_elasticache_replication_group.replication_group.primary_endpoint_address
}

output "reader_endpoint_address" {
  description = "Reader endpoint address for the replication group"
  value       = aws_elasticache_replication_group.replication_group.reader_endpoint_address
}

output "port" {
  description = "Port the replication group is listening on"
  value       = aws_elasticache_replication_group.replication_group.port
}
