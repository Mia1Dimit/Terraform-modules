output "launch_template_id" {
  description = "ID of the EC2 launch template"
  value       = aws_launch_template.template.id
}

output "launch_template_arn" {
  description = "ARN of the EC2 launch template"
  value       = aws_launch_template.template.arn
}

output "launch_template_name" {
  description = "Name of the EC2 launch template"
  value       = aws_launch_template.template.name
}

output "latest_version" {
  description = "Latest version number of the launch template"
  value       = aws_launch_template.template.latest_version
}

output "default_version" {
  description = "Default version number of the launch template"
  value       = aws_launch_template.template.default_version
}