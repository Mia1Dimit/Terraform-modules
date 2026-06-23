resource "aws_subnet" "subnet" {
  vpc_id                          = var.vpc_id
  cidr_block                      = var.cidr_block
  availability_zone               = var.availability_zone
  ipv6_cidr_block                 = var.ipv6_cidr_block
  assign_ipv6_address_on_creation = var.assign_ipv6_address_on_creation
  map_public_ip_on_launch         = var.map_public_ip_on_launch
  enable_dns64                    = var.enable_dns64
  enable_resource_name_dns_a_record_on_launch = var.enable_resource_name_dns_a_record_on_launch
  enable_resource_name_dns_aaaa_record_on_launch = var.enable_resource_name_dns_aaaa_record_on_launch

  tags = local.merged_tags
}
