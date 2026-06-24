variable "asg_name" {
  type        = string
  description = "Name of the Auto Scaling Group"
}

variable "min_size" {
  type        = number
  description = "Minimum number of instances in the ASG"
}

variable "max_size" {
  type        = number
  description = "Maximum number of instances in the ASG"
}

variable "desired_capacity" {
  type        = number
  description = "Desired number of instances in the ASG"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs across which the ASG will launch instances"
}

variable "launch_template_id" {
  type        = string
  description = "ID of the EC2 launch template to use"
  default     = null
}

variable "launch_template_version" {
  type        = string
  description = "Version of the launch template. Defaults to latest"
  default     = "$Latest"
}

variable "health_check_type" {
  type        = string
  description = "Health check type: EC2 or ELB"
  default     = "EC2"

  validation {
    condition     = contains(["EC2", "ELB"], var.health_check_type)
    error_message = "health_check_type must be EC2 or ELB."
  }
}

variable "health_check_grace_period" {
  type        = number
  description = "Seconds after instance launch before checking health"
  default     = 300
}

variable "target_group_arns" {
  type        = list(string)
  description = "List of ALB/NLB target group ARNs"
  default     = []
}

variable "termination_policies" {
  type        = list(string)
  description = "Termination policies for the ASG"
  default     = ["Default"]
}

variable "wait_for_capacity_timeout" {
  type        = string
  description = "Timeout for waiting for desired capacity"
  default     = "10m"
}

variable "protect_from_scale_in" {
  type        = bool
  description = "Protect instances from scale-in"
  default     = false
}

variable "enable_instance_refresh" {
  type        = bool
  description = "Enable rolling instance refresh on launch template changes"
  default     = false
}

variable "instance_refresh_min_healthy_percentage" {
  type        = number
  description = "Minimum healthy percentage during instance refresh"
  default     = 90
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
  description = "Name tag for the Auto Scaling Group"
}

variable "purpose" {
  type        = string
  description = "Purpose of the Auto Scaling Group"
  default     = "Scalable compute for application workloads"
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
    Module           = "auto-scaling-group"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
