variable "budget_name" {
  type = string
}

variable "limit_amount" {
  type = string
}

variable "limit_unit" {
  type    = string
  default = "USD"
}

variable "time_unit" {
  type    = string
  default = "MONTHLY"
}

variable "threshold_percent" {
  type    = number
  default = 80
}

variable "notification_emails" {
  type    = list(string)
  default = []
}

variable "sns_topic_arn" {
  type    = string
  default = null
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
    Name             = var.budget_name
    Module           = "budgets"
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}

locals {
  common_tags = {
    Application_ID   = var.applicationid
    Application_Name = var.applicationname
    Environment      = var.environment
    Name             = var.budget_name
    Module           = "budgets"
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}

locals {
  common_tags = {
    Application_ID   = var.applicationid
    Application_Name = var.applicationname
    Environment      = var.environment
    Name             = var.budget_name
    Module           = "budgets"
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
