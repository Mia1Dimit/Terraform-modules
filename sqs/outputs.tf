output "queue_url" { value = aws_sqs_queue.main.url }
output "queue_arn" { value = aws_sqs_queue.main.arn }
output "queue_name" { value = aws_sqs_queue.main.name }
output "dlq_url" { value = length(aws_sqs_queue.dlq) > 0 ? aws_sqs_queue.dlq[0].url : null }
output "dlq_arn" { value = length(aws_sqs_queue.dlq) > 0 ? aws_sqs_queue.dlq[0].arn : null }
