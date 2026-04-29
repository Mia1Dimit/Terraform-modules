resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id
  tags   = local.merged_tags

}

resource "aws_route" "aws_routes" {
  route_table_id            = aws_route_table.route_table.id
  for_each = var.routes_table
  gateway_id                = each.value["gateway_id"]
  nat_gateway_id            = each.value["nat_gateway_id"]
  transit_gateway_id        = each.value["transit_gateway_id"]
  vpc_endpoint_id           = each.value["vpc_endpoint_id"]
  vpc_peering_connection_id = each.value["vpc_peering_connection_id"]
  destination_cidr_block    = each.value["destination_cidr_block"]
  network_interface_id      = each.value["network_interface_id"]
}

