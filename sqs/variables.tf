variable "queue_name" {
  type = string
}

variable "visibility_timeout" {
  type    = number
  default = 30
}

variable "message_retention_seconds" {
  type    = number
  default = 345600
}

variable "dlq_name" {
  type    = string
  default = null
}

variable "max_receive_count" {
  type    = number
  default = 3
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

variable "name" {
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
    Module           = "sqs"
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
