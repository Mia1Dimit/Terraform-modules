variable "gateway_name" {
  type        = string
  description = "Name of the Bedrock AgentCore Gateway"
}

variable "role_arn" {
  type        = string
  description = "ARN of the IAM role assumed by the gateway"
}

variable "authorizer_type" {
  type        = string
  description = "Type of authorizer. Valid values: CUSTOM_JWT, AWS_IAM"
  default     = "AWS_IAM"

  validation {
    condition     = contains(["CUSTOM_JWT", "AWS_IAM"], var.authorizer_type)
    error_message = "authorizer_type must be CUSTOM_JWT or AWS_IAM."
  }
}

variable "custom_jwt_authorizer" {
  type = object({
    discovery_url    = string
    allowed_audience = optional(set(string))
    allowed_clients  = optional(set(string))
    allowed_scopes   = optional(set(string))
  })
  description = "JWT configuration when authorizer_type is CUSTOM_JWT"
  default     = null
}

variable "description" {
  type        = string
  description = "Description of the gateway"
  default     = null
}

variable "exception_level" {
  type        = string
  description = "Exception level for the gateway"
  default     = null

  validation {
    condition     = var.exception_level == null || contains(["DEBUG"], var.exception_level)
    error_message = "exception_level must be null or DEBUG."
  }
}

variable "kms_key_arn" {
  type        = string
  description = "KMS key ARN for gateway encryption"
  default     = null
}

variable "protocol_type" {
  type        = string
  description = "Gateway protocol type. Valid value: MCP"
  default     = null

  validation {
    condition     = var.protocol_type == null || contains(["MCP"], var.protocol_type)
    error_message = "protocol_type must be null or MCP."
  }
}

variable "mcp_protocol_configuration" {
  type = object({
    instructions               = optional(string)
    search_type                = optional(string)
    supported_versions         = optional(set(string))
    session_timeout_in_seconds = optional(number)
    enable_response_streaming  = optional(bool)
  })
  description = "Protocol configuration for MCP gateways"
  default     = null
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
  description = "Name tag for the gateway"
}

variable "purpose" {
  type        = string
  description = "Purpose of the Bedrock AgentCore Gateway"
  default     = "MCP gateway for agent tool access"
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
    Module           = "bedrockagentcore-gateway"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}