resource "aws_vpc_endpoint" "vpc_endpoint" {
  vpc_id              = var.vpc_id
  service_name        = var.service_name
  vpc_endpoint_type   = var.vpc_endpoint_type
  private_dns_enabled = var.private_dns_enabled

  subnet_ids          = var.vpc_endpoint_type == "Interface" ? var.subnet_ids : null
  security_group_ids  = var.vpc_endpoint_type == "Interface" ? var.security_group_ids : null
  route_table_ids     = var.vpc_endpoint_type == "Gateway" ? var.route_table_ids : null

  ip_address_type = var.vpc_endpoint_type == "Interface" ? var.ip_address_type : null

  policy = var.policy

  tags = local.merged_tags
}
