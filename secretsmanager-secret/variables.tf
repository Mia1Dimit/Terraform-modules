variable "secret_name" {
  description = "Name of the secret. Can include path prefixes (e.g. myapp/prod/db)"
  type        = string
}

variable "description" {
  description = "Description of the secret"
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "ARN or ID of the KMS key used to encrypt the secret. Defaults to AWS-managed key"
  type        = string
  default     = null
}

variable "recovery_window_in_days" {
  description = "Number of days before a deleted secret is permanently removed (7-30). Set 0 to force-delete immediately"
  type        = number
  default     = 30

  validation {
    condition     = var.recovery_window_in_days == 0 || (var.recovery_window_in_days >= 7 && var.recovery_window_in_days <= 30)
    error_message = "recovery_window_in_days must be 0 (force delete) or between 7 and 30."
  }
}

variable "force_overwrite_replica_secret" {
  description = "Whether to overwrite an existing secret in a replica region"
  type        = bool
  default     = false
}

variable "replicas" {
  description = "List of replica regions for multi-region secrets"
  type = list(object({
    region     = string
    kms_key_id = optional(string)
  }))
  default = []
}

variable "secret_string" {
  description = "Initial secret value as a plaintext string or JSON string. Set null to manage value outside this module"
  type        = string
  sensitive   = true
  default     = null
}

variable "rotation_lambda_arn" {
  description = "ARN of the Lambda function that rotates the secret. Set null to disable rotation"
  type        = string
  default     = null
}

variable "rotation_automatically_after_days" {
  description = "Number of days between automatic rotation. Used when rotation_lambda_arn is set"
  type        = number
  default     = 30
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
  description = "Name tag for the secret"
}

variable "purpose" {
  type        = string
  description = "Purpose of the secret"
  default     = "Secrets management"
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
    Module           = "secretsmanager-secret"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
