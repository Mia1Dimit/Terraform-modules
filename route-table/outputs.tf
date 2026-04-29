output "route_table_id" {
  description = "The ID of the created Route Table"
  value = aws_route_table.route_table.id
}