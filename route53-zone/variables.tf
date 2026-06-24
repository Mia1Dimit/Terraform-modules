variable "zone_name" {
  type        = string
  description = "DNS domain name for the hosted zone"
}

variable "comment" {
  type        = string
  description = "Comment for the hosted zone"
  default     = null
}

variable "force_destroy" {
  type        = bool
  description = "Destroy all records in the zone on deletion"
  default     = false
}

variable "private_vpc_ids" {
  type        = list(string)
  description = "List of VPC IDs to associate for a private hosted zone. Leave empty for public zones"
  default     = []
}

variable "vpc_region" {
  type        = string
  description = "AWS region of the associated VPCs for private zones"
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
  description = "Name tag for the hosted zone"
}

variable "purpose" {
  type        = string
  description = "Purpose of the Route53 hosted zone"
  default     = "DNS management for domain"
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
    Module           = "route53-zone"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
