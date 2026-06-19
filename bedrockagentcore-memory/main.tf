resource "aws_bedrockagentcore_memory" "memory" {
  name                  = var.memory_name
  event_expiry_duration = var.event_expiry_duration

  description               = var.description
  encryption_key_arn        = var.encryption_key_arn
  memory_execution_role_arn = var.memory_execution_role_arn

  dynamic "indexed_key" {
    for_each = var.indexed_keys
    content {
      key  = indexed_key.value.key
      type = indexed_key.value.type
    }
  }

  tags = local.merged_tags
}