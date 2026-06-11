variable "agent_name" {
  type        = string
  description = "Name of the Bedrock agent"
}

variable "agent_resource_role_arn" {
  type        = string
  description = "ARN of the IAM role that the agent uses to interact with other AWS services"
}

variable "foundation_model" {
  type        = string
  description = "The foundation model to use for the agent. Examples: anthropic.claude-3-sonnet-20240229-v1:0, anthropic.claude-3-haiku-20240307-v1:0"
  default     = "anthropic.claude-3-5-sonnet-20241022-v2:0"
}

variable "description" {
  type        = string
  default     = null
  description = "Description of the Bedrock agent"
}

variable "idle_session_ttl_in_seconds" {
  type        = number
  default     = 600
  description = "Idle session timeout in seconds for the agent"
}

variable "memory_max_tokens" {
  type        = number
  default     = 4096
  description = "Maximum number of tokens in the agent's memory"
}

variable "memory_ttl_in_seconds" {
  type        = number
  default     = 3600
  description = "Time to live for the agent's memory in seconds"
}

variable "guardrail_configuration" {
  type = object({
    guardrail_id      = string
    guardrail_version = optional(string)
  })
  default     = null
  description = "Configuration for guardrails to apply to the agent"
}

variable "skip_resource_in_use_check" {
  type        = bool
  default     = false
  description = "Whether to skip the resource in-use check during deletion"
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
  description = "Name for the Bedrock agent"
}

variable "purpose" {
  type        = string
  description = "Purpose of the Bedrock agent"
  default     = "AI Agent"
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
    Module           = "bedrockagent-agent"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
