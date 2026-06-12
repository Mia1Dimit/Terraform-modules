variable "vpc_id" {
  description = "ID of the VPC where the endpoint will be created"
  type        = string
}

variable "service_name" {
  description = "Service name for the VPC endpoint (for example com.amazonaws.eu-west-1.s3)"
  type        = string
}

variable "vpc_endpoint_type" {
  description = "Type of the endpoint: Interface or Gateway"
  type        = string
  default     = "Interface"

  validation {
    condition     = contains(["Interface", "Gateway"], var.vpc_endpoint_type)
    error_message = "vpc_endpoint_type must be Interface or Gateway."
  }
}

variable "private_dns_enabled" {
  description = "Whether to associate a private hosted zone with the specified VPC"
  type        = bool
  default     = true
}

variable "subnet_ids" {
  description = "Subnet IDs for Interface endpoints"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Security group IDs for Interface endpoints"
  type        = list(string)
  default     = []
}

variable "route_table_ids" {
  description = "Route table IDs for Gateway endpoints"
  type        = list(string)
  default     = []
}

variable "ip_address_type" {
  description = "IP address type for Interface endpoints: ipv4, dualstack, or ipv6"
  type        = string
  default     = "ipv4"

  validation {
    condition     = contains(["ipv4", "dualstack", "ipv6"], var.ip_address_type)
    error_message = "ip_address_type must be ipv4, dualstack, or ipv6."
  }
}

variable "policy" {
  description = "Policy to attach to the VPC endpoint (JSON)"
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
  description = "Name tag for the endpoint"
}

variable "purpose" {
  type        = string
  description = "Purpose of the VPC endpoint"
  default     = "Private service connectivity"
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
    Module           = "vpc-endpoint"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
