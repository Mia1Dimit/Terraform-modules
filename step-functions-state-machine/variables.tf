variable "state_machine_name" {
  description = "Name of the Step Functions state machine"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN used by the Step Functions state machine"
  type        = string
}

variable "definition" {
  description = "Amazon States Language JSON definition for the state machine"
  type        = string
}

variable "type" {
  description = "Type of the state machine. Valid values: STANDARD or EXPRESS"
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "EXPRESS"], var.type)
    error_message = "type must be STANDARD or EXPRESS."
  }
}

variable "logging_configuration" {
  description = "Optional logging configuration for Step Functions"
  type = object({
    include_execution_data = bool
    level                  = string
    log_destination        = optional(string)
  })
  default = null
}

variable "tracing_enabled" {
  description = "Enable X-Ray tracing for the state machine"
  type        = bool
  default     = false
}

variable "encryption_configuration" {
  description = "Optional encryption configuration for the state machine"
  type = object({
    kms_key_id                        = string
    kms_data_key_reuse_period_seconds = optional(number)
    type                              = optional(string)
  })
  default = null
}

variable "publish" {
  description = "Whether to publish a state machine version on update"
  type        = bool
  default     = false
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
  description = "Name tag for the state machine"
}

variable "purpose" {
  type        = string
  description = "Purpose of the state machine"
  default     = "Workflow orchestration"
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
    Module           = "step-functions-state-machine"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
