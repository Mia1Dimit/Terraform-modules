data "aws_region" "current" {}

data "aws_route_table" "public" {
  route_table_id = aws_route_table.public.id
}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  tags       = merge(local.merged_tags, { Name = var.name })
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags                    = merge(local.merged_tags, { Name = "${var.name}-public" })
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags   = merge(local.merged_tags, { Name = "${var.name}-igw" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = merge(local.merged_tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_vpc_endpoint" "gateway" {
  for_each = toset(var.endpoint_services)

  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.public.id]

  tags = merge(local.merged_tags, { Name = "${var.name}-${each.key}-endpoint" })
}
