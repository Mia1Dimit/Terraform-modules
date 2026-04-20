variable "name" {
  type = string
}

variable "value" {
  type      = string
  sensitive = true
}

variable "type" {
  type    = string
  default = "SecureString"
}

variable "kms_key_id" {
  type    = string
  default = null
}

variable "description" {
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
    Name             = var.name
    Module           = "ssm-parameter"
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
