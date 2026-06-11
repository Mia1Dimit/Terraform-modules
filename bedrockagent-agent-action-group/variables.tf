variable "action_group_name" {
  type        = string
  description = "Name of the action group"
}

variable "agent_id" {
  type        = string
  description = "The unique identifier of the agent to attach the action group to"
}

variable "agent_version" {
  type        = string
  default     = "DRAFT"
  description = "Version of the agent for the action group. Valid values: DRAFT"
}

variable "action_group_state" {
  type        = string
  default     = "ENABLED"
  description = "Whether the action group is available for the agent. Valid values: ENABLED, DISABLED"
}

variable "lambda_arn" {
  type        = string
  description = "ARN of the Lambda function containing the business logic for the action group"
}

variable "api_schema_payload" {
  type        = string
  default     = null
  description = "JSON or YAML-formatted payload defining the OpenAPI schema for the action group"
}

variable "api_schema_s3" {
  type = object({
    bucket_name = string
    object_key  = string
  })
  default     = null
  description = "Details about the S3 object containing the OpenAPI schema for the action group"
}

variable "function_schema" {
  type = object({
    functions = optional(list(object({
      name        = string
      description = optional(string)
      parameters  = optional(map(object({
        type        = string
        description = optional(string)
        required    = optional(bool)
      })))
    })))
  })
  default     = null
  description = "Function schema describing the functions in the action group"
}

variable "description" {
  type        = string
  default     = null
  description = "Description of the action group"
}

variable "skip_resource_in_use_check" {
  type        = bool
  default     = false
  description = "Whether to skip the resource in-use check during deletion"
}

variable "prepare_agent" {
  type        = bool
  default     = true
  description = "Whether to prepare the agent after creating or modifying the action group"
}
