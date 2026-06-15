variable "subnet_id" {
  description = "Subnet ID in which to place the NAT Gateway (must be a public subnet for public NAT)"
  type        = string
}

variable "connectivity_type" {
  description = "Connectivity type: public or private"
  type        = string
  default     = "public"

  validation {
    condition     = contains(["public", "private"], var.connectivity_type)
    error_message = "connectivity_type must be public or private."
  }
}

variable "create_eip" {
  description = "Whether to create a new Elastic IP for the NAT Gateway. Set false to provide an existing allocation_id"
  type        = bool
  default     = true
}

variable "allocation_id" {
  description = "Existing EIP allocation ID to use when create_eip is false and connectivity_type is public"
  type        = string
  default     = null
}

variable "private_ip" {
  description = "Private IPv4 address to assign to a private NAT Gateway"
  type        = string
  default     = null
}

variable "internet_gateway_id" {
  description = "ID of the Internet Gateway. Passed as a depends_on trigger to ensure correct ordering"
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
  description = "Name tag for the NAT Gateway and EIP"
}

variable "purpose" {
  type        = string
  description = "Purpose of the NAT Gateway"
  default     = "Outbound internet access for private subnets"
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
    Module           = "nat-gateway"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
