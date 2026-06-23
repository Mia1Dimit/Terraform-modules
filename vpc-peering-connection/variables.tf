variable "vpc_id" {
  type        = string
  description = "VPC ID of the requester"
}

variable "peer_vpc_id" {
  type        = string
  description = "VPC ID of the peer"
}

variable "peer_region" {
  type        = string
  description = "AWS region of the peer VPC (for cross-region peering)"
  default     = null
}

variable "auto_accept" {
  type        = bool
  description = "Whether to automatically accept the peering connection"
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
  description = "Name tag for the VPC peering connection"
}

variable "purpose" {
  type        = string
  description = "Purpose of the peering connection"
  default     = "VPC-to-VPC connectivity"
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
    Module           = "vpc-peering-connection"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
