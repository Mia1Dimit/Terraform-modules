output "secret_id" {
  description = "ID of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.secretsmanager_secret.id
}

output "secret_arn" {
  description = "ARN of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.secretsmanager_secret.arn
}

output "secret_name" {
  description = "Name of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.secretsmanager_secret.name
}

output "secret_version_id" {
  description = "Version ID of the initial secret value (null if no secret_string provided)"
  value       = length(aws_secretsmanager_secret_version.secretsmanager_secret_version) > 0 ? aws_secretsmanager_secret_version.secretsmanager_secret_version[0].version_id : null
}
