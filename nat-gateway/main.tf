resource "aws_eip" "nat_eip" {
  count  = var.connectivity_type == "public" && var.create_eip ? 1 : 0
  domain = "vpc"

  tags = merge(local.merged_tags, { Name = "${var.name}-eip" })
}

resource "aws_nat_gateway" "nat_gateway" {
  connectivity_type = var.connectivity_type
  subnet_id         = var.subnet_id
  allocation_id     = var.connectivity_type == "public" ? (var.create_eip ? aws_eip.nat_eip[0].id : var.allocation_id) : null
  private_ip        = var.private_ip

  tags = local.merged_tags

  # Ensure the Internet Gateway is ready before the NAT Gateway
  depends_on = [var.internet_gateway_id]
}
