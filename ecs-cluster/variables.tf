variable "cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "container_insights" {
  type        = bool
  description = "Enable CloudWatch Container Insights for the cluster"
  default     = true
}

variable "capacity_providers" {
  type        = list(string)
  description = "List of capacity providers to associate. Use FARGATE, FARGATE_SPOT, or custom providers"
  default     = ["FARGATE", "FARGATE_SPOT"]
}

variable "default_capacity_provider_strategy" {
  type = list(object({
    capacity_provider = string
    weight            = optional(number, 1)
    base              = optional(number, 0)
  }))
  description = "Default capacity provider strategy for the cluster"
  default = [
    {
      capacity_provider = "FARGATE"
      weight            = 1
      base              = 1
    }
  ]
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
  description = "Name tag for the ECS cluster"
}

variable "purpose" {
  type        = string
  description = "Purpose of the ECS cluster"
  default     = "Container orchestration for application workloads"
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
    Module           = "ecs-cluster"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
