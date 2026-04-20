resource "aws_sqs_queue" "main" {
  name                      = var.queue_name
  visibility_timeout_seconds = var.visibility_timeout
  message_retention_seconds = var.message_retention_seconds

  redrive_policy = var.dlq_name != null ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = var.max_receive_count
  }) : null

  tags = local.merged_tags
}

resource "aws_sqs_queue" "dlq" {
  count = var.dlq_name != null ? 1 : 0

  name                      = var.dlq_name
  message_retention_seconds = var.message_retention_seconds
  tags                      = local.merged_tags
}
