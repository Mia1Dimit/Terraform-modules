resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = var.load_balancer_arn
  port              = var.port
  protocol          = var.protocol
  ssl_policy        = var.protocol == "HTTPS" ? var.ssl_policy : null
  certificate_arn   = var.protocol == "HTTPS" ? var.certificate_arn : null

  default_action {
    type             = var.default_action_type
    target_group_arn = var.default_action_type == "forward" ? var.target_group_arn : null

    dynamic "redirect" {
      for_each = var.default_action_type == "redirect" ? [1] : []
      content {
        port        = var.redirect_config.port
        protocol    = var.redirect_config.protocol
        status_code = var.redirect_config.status_code
      }
    }

    dynamic "fixed_response" {
      for_each = var.default_action_type == "fixed-response" ? [1] : []
      content {
        content_type = var.fixed_response_config.content_type
        message_body = var.fixed_response_config.message_body
        status_code  = var.fixed_response_config.status_code
      }
    }
  }
}
