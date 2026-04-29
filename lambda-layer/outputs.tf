output "layer_arn" {
  description = "ARN of the created Lambda layer"
  value       = aws_lambda_layer_version.layer.arn
}

output "layer_name" {
  description = "Name of the layer"
  value       = aws_lambda_layer_version.layer.layer_name
}

output "layer_version" {
  description = "Version number of the layer"
  value       = aws_lambda_layer_version.layer.version
}
