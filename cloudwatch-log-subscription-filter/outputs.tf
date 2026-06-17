output "filter_name" {
  description = "Name of the CloudWatch log subscription filter"
  value       = aws_cloudwatch_log_subscription_filter.cloudwatch_log_subscription_filter.name
}

output "log_group_name" {
  description = "Log group the subscription filter is attached to"
  value       = aws_cloudwatch_log_subscription_filter.cloudwatch_log_subscription_filter.log_group_name
}

output "destination_arn" {
  description = "ARN of the destination for matched log events"
  value       = aws_cloudwatch_log_subscription_filter.cloudwatch_log_subscription_filter.destination_arn
}
