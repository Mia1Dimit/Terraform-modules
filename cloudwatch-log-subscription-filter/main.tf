resource "aws_cloudwatch_log_subscription_filter" "cloudwatch_log_subscription_filter" {
  name            = var.filter_name
  log_group_name  = var.log_group_name
  filter_pattern  = var.filter_pattern
  destination_arn = var.destination_arn
  distribution    = var.distribution
  role_arn        = var.role_arn
}
