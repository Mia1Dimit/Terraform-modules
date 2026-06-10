variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "Tag mutability setting for the repository: MUTABLE or IMMUTABLE"
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "image_tag_mutability must be MUTABLE or IMMUTABLE."
  }
}

variable "scan_on_push" {
  description = "Whether images are scanned for vulnerabilities after being pushed"
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "Encryption type for repository images: AES256 or KMS"
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "encryption_type must be AES256 or KMS."
  }
}

variable "kms_key_arn" {
  description = "KMS key ARN used when encryption_type is KMS"
  type        = string
  default     = null
}

variable "force_delete" {
  description = "If true, delete the repository even when it contains images"
  type        = bool
  default     = false
}

variable "lifecycle_policy" {
  description = "Lifecycle policy JSON for image retention. Set null to skip"
  type        = string
  default     = null
}

variable "repository_policy" {
  description = "Repository policy JSON document. Set null to skip"
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
  description = "Name tag for the repository"
}

variable "purpose" {
  type        = string
  description = "Purpose of the ECR repository"
  default     = "Container images"
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
    Module           = "ecr-repository"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
