resource "aws_ssm_parameter" "ssm_parameter" {
  name        = var.name
  description = var.description
  type        = var.type
  value       = var.value
  key_id      = var.type == "SecureString" ? var.kms_key_id : null

  tags = local.merged_tags
}
