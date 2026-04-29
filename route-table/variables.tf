variable "vpc_id" {
  description = "VPC ID where the route table will be created"
  type        = string
}


variable "routes_table" {
  description = "Maps of all possible route table"
  type = map(object({
      gateway_id                = optional(string)
      nat_gateway_id            = optional(string)
      transit_gateway_id        = optional(string)
      vpc_endpoint_id           = optional(string)
      vpc_peering_connection_id = optional(string)
      destination_cidr_block    = optional(string)
      network_interface_id      = optional(string)
  }))
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
  description = "Name of the Route Table"
  type        = string
}

variable "specifictags" {
  type        = map(string)
  description = "Specific tags for the resource"
  default     = {}
}

variable "purpose" {
  type        = string
  description = "Purpose of the route table"
  default     = "Route Table for managing network traffic"
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
    Module           = "route-table"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}