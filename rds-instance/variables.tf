variable "identifier" {
  description = "Unique identifier for the RDS instance"
  type        = string
}

variable "engine" {
  description = "Database engine: mysql, postgres, mariadb, oracle-se2, sqlserver-se, etc."
  type        = string
}

variable "engine_version" {
  description = "Engine version (e.g. 8.0 for MySQL, 15 for PostgreSQL)"
  type        = string
}

variable "instance_class" {
  description = "Instance type for the RDS instance (e.g. db.t3.micro)"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Name of the initial database. Leave null for SQL Server or Oracle"
  type        = string
  default     = null
}

variable "username" {
  description = "Master username for the database"
  type        = string
}

variable "password" {
  description = "Master password for the database. Stored in state; use Secrets Manager for production"
  type        = string
  sensitive   = true
}

variable "allocated_storage" {
  description = "Initial storage size in GiB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum storage for autoscaling in GiB. Set to 0 or equal to allocated_storage to disable"
  type        = number
  default     = 0
}

variable "storage_type" {
  description = "Storage type: gp2, gp3, io1, io2, or standard"
  type        = string
  default     = "gp3"
}

variable "storage_encrypted" {
  description = "Whether to encrypt the DB storage"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key ARN for storage encryption"
  type        = string
  default     = null
}

variable "iops" {
  description = "Provisioned IOPS. Required for io1/io2; optional for gp3"
  type        = number
  default     = null
}

variable "create_subnet_group" {
  description = "Whether to create a new DB subnet group. Set false to reference an existing one via db_subnet_group_name"
  type        = bool
  default     = true
}

variable "db_subnet_group_name" {
  description = "Name for the DB subnet group. Auto-generated when create_subnet_group is true and this is null"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Subnet IDs for the DB subnet group (required when create_subnet_group is true)"
  type        = list(string)
  default     = []
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs to associate"
  type        = list(string)
  default     = []
}

variable "publicly_accessible" {
  description = "Whether the DB instance is publicly accessible"
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment for high availability"
  type        = bool
  default     = false
}

variable "availability_zone" {
  description = "Availability zone for single-AZ deployments"
  type        = string
  default     = null
}

variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate"
  type        = string
  default     = null
}

variable "option_group_name" {
  description = "Name of the DB option group to associate"
  type        = string
  default     = null
}

variable "backup_retention_period" {
  description = "Number of days to retain automated backups (0 to disable)"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Daily UTC time range for automated backups (e.g. 03:00-04:00)"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Weekly UTC time range for maintenance (e.g. Mon:04:00-Mon:05:00)"
  type        = string
  default     = "Mon:04:00-Mon:05:00"
}

variable "copy_tags_to_snapshot" {
  description = "Copy instance tags to snapshots"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on deletion. Set false and provide final_snapshot_identifier for production"
  type        = bool
  default     = true
}

variable "final_snapshot_identifier" {
  description = "Name of the final snapshot when skip_final_snapshot is false"
  type        = string
  default     = null
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Automatically apply minor engine upgrades during the maintenance window"
  type        = bool
  default     = true
}

variable "allow_major_version_upgrade" {
  description = "Allow major version upgrades"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Apply changes immediately rather than at next maintenance window"
  type        = bool
  default     = false
}

variable "performance_insights_enabled" {
  description = "Enable Performance Insights"
  type        = bool
  default     = false
}

variable "performance_insights_kms_key_id" {
  description = "KMS key ARN for Performance Insights data encryption"
  type        = string
  default     = null
}

variable "performance_insights_retention_period" {
  description = "Retention period for Performance Insights data in days (7 or 731)"
  type        = number
  default     = 7
}

variable "monitoring_interval" {
  description = "Interval in seconds for Enhanced Monitoring (0 to disable; valid: 0,1,5,10,15,30,60)"
  type        = number
  default     = 0
}

variable "monitoring_role_arn" {
  description = "IAM role ARN for Enhanced Monitoring. Required when monitoring_interval > 0"
  type        = string
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch (e.g. [\"error\",\"slowquery\"] for MySQL)"
  type        = list(string)
  default     = []
}

variable "iam_database_authentication_enabled" {
  description = "Enable IAM database authentication"
  type        = bool
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
  description = "Name tag for the RDS instance"
}

variable "purpose" {
  type        = string
  description = "Purpose of the RDS instance"
  default     = "Relational database"
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
    Module           = "rds-instance"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
