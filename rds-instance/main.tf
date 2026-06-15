resource "aws_db_subnet_group" "db_subnet_group" {
  count = var.create_subnet_group ? 1 : 0

  name        = var.db_subnet_group_name != null ? var.db_subnet_group_name : "${var.identifier}-subnet-group"
  description = "Subnet group for RDS instance ${var.identifier}"
  subnet_ids  = var.subnet_ids

  tags = local.merged_tags
}

resource "aws_db_instance" "db_instance" {
  identifier     = var.identifier
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  db_name  = var.db_name
  username = var.username
  password = var.password

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = var.storage_type
  storage_encrypted     = var.storage_encrypted
  kms_key_id            = var.kms_key_id
  iops                  = var.iops

  db_subnet_group_name   = var.create_subnet_group ? aws_db_subnet_group.db_subnet_group[0].name : var.db_subnet_group_name
  vpc_security_group_ids = var.vpc_security_group_ids
  publicly_accessible    = var.publicly_accessible
  multi_az               = var.multi_az
  availability_zone      = var.multi_az ? null : var.availability_zone

  parameter_group_name = var.parameter_group_name
  option_group_name    = var.option_group_name

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window
  copy_tags_to_snapshot   = var.copy_tags_to_snapshot
  skip_final_snapshot     = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : var.final_snapshot_identifier
  deletion_protection     = var.deletion_protection

  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  allow_major_version_upgrade = var.allow_major_version_upgrade
  apply_immediately           = var.apply_immediately

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_enabled ? var.performance_insights_kms_key_id : null
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null

  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_interval > 0 ? var.monitoring_role_arn : null

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  tags = local.merged_tags

  timeouts {
    create = "40m"
    update = "80m"
    delete = "60m"
  }
}
