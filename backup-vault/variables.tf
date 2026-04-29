variable "name" {
  description = "The name of the backup vault"
  type        = string
}

variable "kms_key_arn" {
  description = "The server-side encryption key that is used to protect your backups"
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "A boolean that indicates that all recovery points stored in the vault are deleted so that the vault can be destroyed without error"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the queue"
  type        = map(string)
  default     = {}
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
  description = "Name of the Backup Vault"
  type        = string
}

variable "specifictags" {
  type        = map(string)
  description = "Specific tags for the resource"
  default     = {}
}

variable "purpose" {
  type        = string
  description = "Purpose of the backup vault"
  default     = "Backup Vault for storing recovery points"
}

# -----------------------------------------------------------------------------
# Locals - Tag Merging Strategy
# -----------------------------------------------------------------------------
locals {
  common_tags = {
    Application_ID   = var.applicationid
    Application_Name = var.applicationname
    Environment      = var.environment
    Name             = var.name
    Module           = "backup-vault"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}