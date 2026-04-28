output "backup_vault_id" {
  description = "The ID of the created backup vault"
  value       = aws_backup_vault.backup_vault.id
}

output "backup_vault_arn" {
  description = "The ARN of the created backup vault"
  value       = aws_backup_vault.backup_vault.arn
}