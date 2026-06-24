variable "replication_group_id" {
  type        = string
  description = "Identifier for the ElastiCache replication group"
}

variable "description" {
  type        = string
  description = "Human-readable description of the replication group"
}

variable "node_type" {
  type        = string
  description = "ElastiCache node type (for example cache.t3.micro)"
}

variable "engine" {
  type        = string
  description = "Cache engine: redis or valkey"
  default     = "redis"

  validation {
    condition     = contains(["redis", "valkey"], var.engine)
    error_message = "engine must be redis or valkey."
  }
}

variable "engine_version" {
  type        = string
  description = "Cache engine version"
  default     = "7.1"
}

variable "port" {
  type        = number
  description = "Port number for the cache cluster"
  default     = 6379
}

variable "num_cache_clusters" {
  type        = number
  description = "Number of cache clusters (nodes) in the replication group. Used when automatic_failover_enabled is false"
  default     = 1
}

variable "automatic_failover_enabled" {
  type        = bool
  description = "Enable automatic failover. Requires num_node_groups > 1"
  default     = false
}

variable "num_node_groups" {
  type        = number
  description = "Number of node groups (shards) for cluster mode. Used when automatic_failover_enabled is true"
  default     = 1
}

variable "replicas_per_node_group" {
  type        = number
  description = "Number of replicas per node group. Used when automatic_failover_enabled is true"
  default     = 1
}

variable "multi_az_enabled" {
  type        = bool
  description = "Enable Multi-AZ support"
  default     = false
}

variable "at_rest_encryption_enabled" {
  type        = bool
  description = "Enable encryption at rest"
  default     = true
}

variable "transit_encryption_enabled" {
  type        = bool
  description = "Enable in-transit encryption (TLS)"
  default     = true
}

variable "auth_token" {
  type        = string
  description = "Auth token for Redis AUTH when transit_encryption_enabled is true"
  default     = null
  sensitive   = true
}

variable "subnet_group_name" {
  type        = string
  description = "ElastiCache subnet group name"
  default     = null
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs to associate"
  default     = []
}

variable "apply_immediately" {
  type        = bool
  description = "Apply changes immediately or during maintenance window"
  default     = false
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Enable automatic minor version upgrades"
  default     = true
}

variable "maintenance_window" {
  type        = string
  description = "Weekly maintenance window (for example sun:05:00-sun:06:00)"
  default     = "sun:05:00-sun:06:00"
}

variable "snapshot_retention_limit" {
  type        = number
  description = "Number of days to retain snapshots (0 disables)"
  default     = 7
}

variable "snapshot_window" {
  type        = string
  description = "Daily snapshot window (for example 03:00-04:00)"
  default     = "03:00-04:00"
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
  description = "Name tag for the replication group"
}

variable "purpose" {
  type        = string
  description = "Purpose of the ElastiCache replication group"
  default     = "In-memory caching layer"
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
    Module           = "elasticache-replication-group"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
