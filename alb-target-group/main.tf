resource "aws_lb_target_group" "alb_target_group" {
  name        = var.target_group_name
  port        = var.target_type == "lambda" ? null : var.port
  protocol    = var.target_type == "lambda" ? null : var.protocol
  vpc_id      = var.target_type == "lambda" ? null : var.vpc_id
  target_type = var.target_type

  deregistration_delay = var.target_type == "lambda" ? null : var.deregistration_delay

  dynamic "health_check" {
    for_each = var.target_type == "lambda" ? [] : [1]
    content {
      enabled             = var.health_check.enabled
      healthy_threshold   = var.health_check.healthy_threshold
      interval            = var.health_check.interval
      matcher             = var.health_check.matcher
      path                = var.health_check.path
      port                = var.health_check.port
      protocol            = var.health_check.protocol
      timeout             = var.health_check.timeout
      unhealthy_threshold = var.health_check.unhealthy_threshold
    }
  }

  tags = local.merged_tags
}

resource "aws_lb_target_group_attachment" "alb_target_group_attachment" {
  count = var.target_id != null ? 1 : 0

  target_group_arn = aws_lb_target_group.alb_target_group.arn
  target_id        = var.target_id
  port             = var.target_type == "lambda" ? null : var.target_port
}
