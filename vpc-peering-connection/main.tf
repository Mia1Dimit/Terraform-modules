resource "aws_vpc_peering_connection" "peering" {
  vpc_id      = var.vpc_id
  peer_vpc_id = var.peer_vpc_id
  peer_region = var.peer_region

  tags = local.merged_tags
}

resource "aws_vpc_peering_connection_accepter" "peering_accepter" {
  count = var.auto_accept ? 1 : 0

  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
  auto_accept               = true
}
