output "vpc_id" { value = aws_vpc.vpc.id }
output "public_subnet_id" { value = aws_subnet.public.id }
output "route_table_id" { value = aws_route_table.public.id }
output "vpc_endpoint_ids" { value = { for k, v in aws_vpc_endpoint.gateway : k => v.id } }
