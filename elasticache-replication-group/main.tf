resource "aws_elasticache_replication_group" "replication_group" {
  replication_group_id = var.replication_group_id
  description          = var.description
  node_type            = var.node_type
  port                 = var.port
  engine               = var.engine
  engine_version       = var.engine_version
  num_cache_clusters   = var.automatic_failover_enabled ? null : var.num_cache_clusters
  num_node_groups      = var.automatic_failover_enabled ? var.num_node_groups : null
  replicas_per_node_group = var.automatic_failover_enabled ? var.replicas_per_node_group : null

  automatic_failover_enabled = var.automatic_failover_enabled
  multi_az_enabled           = var.multi_az_enabled
  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  auth_token                 = var.transit_encryption_enabled ? var.auth_token : null

  subnet_group_name  = var.subnet_group_name
  security_group_ids = var.security_group_ids

  apply_immediately          = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  maintenance_window         = var.maintenance_window
  snapshot_retention_limit   = var.snapshot_retention_limit
  snapshot_window            = var.snapshot_window

  tags = local.merged_tags
}
