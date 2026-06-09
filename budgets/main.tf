resource "aws_budgets_budget" "budget" {
  name         = var.budget_name
  budget_type  = "COST"
  limit_amount = var.limit_amount
  limit_unit   = var.limit_unit
  time_unit    = var.time_unit

  cost_types {
    include_credit             = false
    include_discount           = true
    include_other_subscription = true
    include_recurring          = true
    include_refund             = false
    include_subscription       = true
    include_support            = true
    include_tax                = true
    include_upfront            = true
    use_amortized              = false
    use_blended                = false
  }

  dynamic "notification" {
    for_each = toset(var.notification_emails)
    content {
      comparison_operator       = "GREATER_THAN"
      threshold                 = var.threshold_percent
      threshold_type            = "PERCENTAGE"
      notification_type         = "ACTUAL"
      subscriber_email_addresses = [notification.value]
    }
  }

  tags = local.merged_tags
}
