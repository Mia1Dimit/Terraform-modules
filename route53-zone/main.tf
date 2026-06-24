resource "aws_route53_zone" "zone" {
  name          = var.zone_name
  comment       = var.comment
  force_destroy = var.force_destroy

  dynamic "vpc" {
    for_each = var.private_vpc_ids
    content {
      vpc_id     = vpc.value
      vpc_region = var.vpc_region
    }
  }

  tags = local.merged_tags
}
