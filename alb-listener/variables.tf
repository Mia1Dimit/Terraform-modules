variable "load_balancer_arn" {
  description = "ARN of the ALB where this listener is created"
  type        = string
}

variable "port" {
  description = "Listener port"
  type        = number
}

variable "protocol" {
  description = "Listener protocol: HTTP or HTTPS"
  type        = string
  default     = "HTTP"

  validation {
    condition     = contains(["HTTP", "HTTPS"], var.protocol)
    error_message = "protocol must be HTTP or HTTPS."
  }
}

variable "ssl_policy" {
  description = "SSL policy for HTTPS listeners"
  type        = string
  default     = "ELBSecurityPolicy-2016-08"
}

variable "certificate_arn" {
  description = "Certificate ARN for HTTPS listeners"
  type        = string
  default     = null
}

variable "default_action_type" {
  description = "Default action type: forward, redirect, or fixed-response"
  type        = string
  default     = "forward"

  validation {
    condition     = contains(["forward", "redirect", "fixed-response"], var.default_action_type)
    error_message = "default_action_type must be forward, redirect, or fixed-response."
  }
}

variable "target_group_arn" {
  description = "Target group ARN used when default_action_type is forward"
  type        = string
  default     = null
}

variable "redirect_config" {
  description = "Redirect configuration used when default_action_type is redirect"
  type = object({
    port        = string
    protocol    = string
    status_code = string
  })
  default = {
    port        = "443"
    protocol    = "HTTPS"
    status_code = "HTTP_301"
  }
}

variable "fixed_response_config" {
  description = "Fixed response configuration used when default_action_type is fixed-response"
  type = object({
    content_type = string
    message_body = optional(string)
    status_code  = string
  })
  default = {
    content_type = "text/plain"
    message_body = "Not Found"
    status_code  = "404"
  }
}

variable "environment" {
  type        = string
  description = "Environment Tag"
}

variable "applicationid" {
  type        = string
  description = "Application_ID Tag"
}

variable "applicationname" {
  type        = string
  description = "Application_Name Tag"
}

variable "name" {
  type        = string
  description = "Name tag for the listener (kept for interface consistency)"
}

variable "purpose" {
  type        = string
  description = "Purpose of the listener"
  default     = "ALB traffic routing"
}

variable "specifictags" {
  type        = map(string)
  description = "Specific tags for interface consistency"
  default     = {}
}
