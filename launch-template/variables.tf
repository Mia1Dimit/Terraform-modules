variable "launch_template_name" {
  type        = string
  description = "Name of the EC2 launch template"
}

variable "description" {
  type        = string
  description = "Description of the launch template"
  default     = null
}

variable "image_id" {
  type        = string
  description = "AMI ID to use"
}

variable "instance_type" {
  type        = string
  description = "Instance type for launched instances"
}

variable "key_name" {
  type        = string
  description = "Key pair name for SSH access"
  default     = null
}

variable "iam_instance_profile_name" {
  type        = string
  description = "IAM instance profile name"
  default     = null
}

variable "user_data" {
  type        = string
  description = "Base64-encoded user data script"
  default     = null
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "Security group IDs attached to instances"
  default     = []
}

variable "update_default_version" {
  type        = bool
  description = "Whether to update default version to latest"
  default     = true
}

variable "ebs_optimized" {
  type        = bool
  description = "Whether instances are EBS optimized"
  default     = null
}

variable "ebs_root_volume" {
  type = object({
    device_name           = string
    volume_size           = number
    volume_type           = optional(string, "gp3")
    delete_on_termination = optional(bool, true)
    encrypted             = optional(bool, true)
  })
  description = "Optional root EBS volume configuration"
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
  description = "Name tag for launched instances"
}

variable "purpose" {
  type        = string
  description = "Purpose of the launch template"
  default     = "Reusable EC2 compute template"
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
    Module           = "launch-template"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}