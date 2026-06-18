variable "name" {
  description = "Friendly name of the IAM managed policy"
  type        = string
}

variable "path" {
  description = "Path to the policy"
  type        = string
  default     = "/"
}

variable "description" {
  description = "Description of the policy"
  type        = string
  default     = null
}

variable "policy" {
  description = "IAM policy document in JSON format"
  type        = string
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

variable "purpose" {
  type        = string
  description = "Purpose of the IAM policy"
  default     = "Managed IAM permissions"
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
    Module           = "iam-policy"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
