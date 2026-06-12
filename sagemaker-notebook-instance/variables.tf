variable "notebook_instance_name" {
  description = "Name of the SageMaker notebook instance"
  type        = string
}

variable "role_arn" {
  description = "IAM role ARN for the notebook instance"
  type        = string
}

variable "instance_type" {
  description = "ML compute instance type for the notebook"
  type        = string
  default     = "ml.t3.medium"
}

variable "platform_identifier" {
  description = "Platform identifier for the notebook instance"
  type        = string
  default     = null
}

variable "volume_size" {
  description = "Size in GB of the ML storage volume"
  type        = number
  default     = 20
}

variable "kms_key_id" {
  description = "KMS key ID used to encrypt the storage volume"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet ID for VPC placement"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "Security group IDs for VPC placement"
  type        = list(string)
  default     = []
}

variable "direct_internet_access" {
  description = "Whether direct internet access is enabled: Enabled or Disabled"
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.direct_internet_access)
    error_message = "direct_internet_access must be Enabled or Disabled."
  }
}

variable "root_access" {
  description = "Whether root access is enabled: Enabled or Disabled"
  type        = string
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.root_access)
    error_message = "root_access must be Enabled or Disabled."
  }
}

variable "lifecycle_config_name" {
  description = "Name of a lifecycle configuration to associate"
  type        = string
  default     = null
}

variable "default_code_repository" {
  description = "Default Git repository to clone"
  type        = string
  default     = null
}

variable "additional_code_repositories" {
  description = "Additional Git repositories to clone"
  type        = list(string)
  default     = []
}

variable "accelerator_types" {
  description = "List of Elastic Inference accelerator types"
  type        = list(string)
  default     = []
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
  description = "Name tag for the notebook"
}

variable "purpose" {
  type        = string
  description = "Purpose of the SageMaker notebook"
  default     = "Interactive ML development"
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
    Module           = "sagemaker-notebook-instance"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
