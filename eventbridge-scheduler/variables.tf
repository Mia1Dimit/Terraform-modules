variable "name" {
  type = string
}

variable "schedule_expression" {
  type = string
}

variable "target_arn" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "input" {
  type    = string
  default = null
}

variable "flexible_time_window_mode" {
  type    = string
  default = "OFF"
}

variable "state" {
  type    = string
  default = "ENABLED"
}

variable "environment" {
  type = string
}

variable "applicationid" {
  type = string
}

variable "applicationname" {
  type = string
}

variable "specifictags" {
  type    = map(string)
  default = {}
}

locals {
  common_tags = {
    Application_ID   = var.applicationid
    Application_Name = var.applicationname
    Environment      = var.environment
    Name             = var.name
    Module           = "eventbridge-scheduler"
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
