variable "domain_name" {
  type        = string
  description = "Primary domain name for the ACM certificate"
}

variable "subject_alternative_names" {
  type        = list(string)
  description = "Subject Alternative Names for the certificate"
  default     = []
}

variable "validation_method" {
  type        = string
  description = "Certificate validation method. Valid values: DNS, EMAIL"
  default     = "DNS"

  validation {
    condition     = contains(["DNS", "EMAIL"], var.validation_method)
    error_message = "validation_method must be DNS or EMAIL."
  }
}

variable "key_algorithm" {
  type        = string
  description = "Key algorithm for certificate"
  default     = "RSA_2048"
}

variable "certificate_transparency_logging_preference" {
  type        = string
  description = "Certificate transparency logging preference"
  default     = "ENABLED"

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.certificate_transparency_logging_preference)
    error_message = "certificate_transparency_logging_preference must be ENABLED or DISABLED."
  }
}

variable "export" {
  type        = string
  description = "Whether certificate can be exported. Valid values: ENABLED, DISABLED"
  default     = "DISABLED"

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.export)
    error_message = "export must be ENABLED or DISABLED."
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
  description = "Name tag for the certificate"
}

variable "purpose" {
  type        = string
  description = "Purpose of the ACM certificate"
  default     = "TLS certificate for AWS services"
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
    Module           = "acm-certificate"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}