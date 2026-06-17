variable "filter_name" {
  description = "Name of the CloudWatch log subscription filter"
  type        = string
}

variable "log_group_name" {
  description = "Name of the CloudWatch log group to attach the filter to"
  type        = string
}

variable "filter_pattern" {
  description = "Filter pattern to match log events. Use empty string to match all events"
  type        = string
  default     = ""
}

variable "destination_arn" {
  description = "ARN of the destination to deliver matching log events (Lambda, Kinesis stream, or Kinesis Firehose)"
  type        = string
}

variable "distribution" {
  description = "Distribution method for log data: ByLogStream or Random"
  type        = string
  default     = "ByLogStream"

  validation {
    condition     = contains(["ByLogStream", "Random"], var.distribution)
    error_message = "distribution must be ByLogStream or Random."
  }
}

variable "role_arn" {
  description = "IAM role ARN to use when delivering logs to a Kinesis stream or Firehose destination. Not required for Lambda"
  type        = string
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
  description = "Name tag for the subscription filter (kept for interface consistency)"
}

variable "purpose" {
  type        = string
  description = "Purpose of the subscription filter"
  default     = "Log event forwarding"
}

variable "specifictags" {
  type        = map(string)
  description = "Specific tags for interface consistency"
  default     = {}
}
