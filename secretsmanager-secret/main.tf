resource "aws_secretsmanager_secret" "secretsmanager_secret" {
  name                    = var.secret_name
  description             = var.description
  kms_key_id              = var.kms_key_id
  recovery_window_in_days = var.recovery_window_in_days
  force_overwrite_replica_secret = var.force_overwrite_replica_secret

  dynamic "replica" {
    for_each = var.replicas
    content {
      region     = replica.value.region
      kms_key_id = lookup(replica.value, "kms_key_id", null)
    }
  }

  tags = local.merged_tags
}

resource "aws_secretsmanager_secret_version" "secretsmanager_secret_version" {
  count = var.secret_string != null ? 1 : 0

  secret_id     = aws_secretsmanager_secret.secretsmanager_secret.id
  secret_string = var.secret_string
}

resource "aws_secretsmanager_secret_rotation" "secretsmanager_secret_rotation" {
  count = var.rotation_lambda_arn != null ? 1 : 0

  secret_id           = aws_secretsmanager_secret.secretsmanager_secret.id
  rotation_lambda_arn = var.rotation_lambda_arn

  rotation_rules {
    automatically_after_days = var.rotation_automatically_after_days
  }
}
