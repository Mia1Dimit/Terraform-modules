variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "target_type" {
  description = "Type of targets registered with this target group: instance, ip, or lambda"
  type        = string
  default     = "ip"

  validation {
    condition     = contains(["instance", "ip", "lambda"], var.target_type)
    error_message = "target_type must be instance, ip, or lambda."
  }
}

variable "vpc_id" {
  description = "VPC ID for the target group (required for instance/ip target types)"
  type        = string
  default     = null
}

variable "port" {
  description = "Port on which targets receive traffic"
  type        = number
  default     = 80
}

variable "protocol" {
  description = "Protocol used by the target group: HTTP or HTTPS"
  type        = string
  default     = "HTTP"

  validation {
    condition     = contains(["HTTP", "HTTPS"], var.protocol)
    error_message = "protocol must be HTTP or HTTPS."
  }
}

variable "deregistration_delay" {
  description = "Amount of time for Elastic Load Balancing to wait before changing the state of a deregistering target"
  type        = number
  default     = 300
}

variable "health_check" {
  description = "Health check settings for non-lambda target groups"
  type = object({
    enabled             = bool
    healthy_threshold   = number
    interval            = number
    matcher             = string
    path                = string
    port                = string
    protocol            = string
    timeout             = number
    unhealthy_threshold = number
  })
  default = {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

variable "target_id" {
  description = "Optional target ID to attach immediately (instance ID, IP address, or Lambda ARN)"
  type        = string
  default     = null
}

variable "target_port" {
  description = "Port used when attaching a non-lambda target"
  type        = number
  default     = 80
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
  description = "Name tag for the target group"
}

variable "purpose" {
  type        = string
  description = "Purpose of the target group"
  default     = "Route ALB traffic to targets"
}

variable "specifictags" {
  type        = map(string)
  description = "Specific tags for the resource"
  default     = {}
}

locals {
  common_tags = {
    Application_ID   = var.applicationid
    Application_Name = var.applicationname
    Environment      = var.environment
    Name             = var.name
    Module           = "alb-target-group"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
