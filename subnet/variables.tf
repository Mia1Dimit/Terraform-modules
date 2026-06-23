variable "vpc_id" {
  type        = string
  description = "VPC ID where the subnet will be created"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the subnet"
}

variable "availability_zone" {
  type        = string
  description = "Availability Zone for the subnet"
  default     = null
}

variable "ipv6_cidr_block" {
  type        = string
  description = "IPv6 CIDR block for the subnet"
  default     = null
}

variable "assign_ipv6_address_on_creation" {
  type        = bool
  description = "Assign IPv6 address on instance creation"
  default     = false
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Assign public IP on instance launch (for public subnets)"
  default     = false
}

variable "enable_dns64" {
  type        = bool
  description = "Enable DNS64 for IPv6"
  default     = false
}

variable "enable_resource_name_dns_a_record_on_launch" {
  type        = bool
  description = "Enable DNS A record on instance launch"
  default     = false
}

variable "enable_resource_name_dns_aaaa_record_on_launch" {
  type        = bool
  description = "Enable DNS AAAA record on instance launch"
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
  description = "Name tag for the subnet"
}

variable "purpose" {
  type        = string
  description = "Purpose of the subnet"
  default     = "VPC subnet for compute resources"
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
    Module           = "subnet"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
