resource "aws_sfn_state_machine" "state_machine" {
  name       = var.state_machine_name
  role_arn   = var.role_arn
  definition = var.definition
  type       = var.type
  publish    = var.publish

  dynamic "logging_configuration" {
    for_each = var.logging_configuration != null ? [var.logging_configuration] : []
    content {
      include_execution_data = logging_configuration.value.include_execution_data
      level                  = logging_configuration.value.level

      dynamic "log_destination" {
        for_each = logging_configuration.value.log_destination != null ? [logging_configuration.value.log_destination] : []
        content {
          cloudwatch_logs_log_group {
            log_group_arn = log_destination.value
          }
        }
      }
    }
  }

  tracing_configuration {
    enabled = var.tracing_enabled
  }

  dynamic "encryption_configuration" {
    for_each = var.encryption_configuration != null ? [var.encryption_configuration] : []
    content {
      kms_key_id                        = encryption_configuration.value.kms_key_id
      kms_data_key_reuse_period_seconds = lookup(encryption_configuration.value, "kms_data_key_reuse_period_seconds", null)
      type                              = lookup(encryption_configuration.value, "type", null)
    }
  }

  tags = local.merged_tags
}
