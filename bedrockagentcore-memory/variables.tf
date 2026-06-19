variable "memory_name" {
  type        = string
  description = "Name of the Bedrock AgentCore Memory"
}

variable "event_expiry_duration" {
  type        = number
  description = "Number of days after which memory events expire (7-365)"
  default     = 30

  validation {
    condition     = var.event_expiry_duration >= 7 && var.event_expiry_duration <= 365
    error_message = "event_expiry_duration must be between 7 and 365 days."
  }
}

variable "description" {
  type        = string
  description = "Description of the memory"
  default     = null
}

variable "encryption_key_arn" {
  type        = string
  description = "KMS key ARN for memory encryption"
  default     = null
}

variable "memory_execution_role_arn" {
  type        = string
  description = "Execution role ARN for custom memory strategies"
  default     = null
}

variable "indexed_keys" {
  type = list(object({
    key  = string
    type = string
  }))
  description = "Indexed metadata keys for filtering"
  default     = []

  validation {
    condition = alltrue([
      for v in var.indexed_keys : contains(["STRING", "STRINGLIST", "NUMBER"], v.type)
    ])
    error_message = "Each indexed key type must be STRING, STRINGLIST, or NUMBER."
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
  description = "Name tag for the memory resource"
}

variable "purpose" {
  type        = string
  description = "Purpose of the Bedrock AgentCore Memory"
  default     = "Persistent memory for agent interactions"
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
    Module           = "bedrockagentcore-memory"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}