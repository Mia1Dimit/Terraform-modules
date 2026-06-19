output "gateway_id" {
  description = "Unique identifier of the Bedrock AgentCore Gateway"
  value       = aws_bedrockagentcore_gateway.gateway.gateway_id
}

output "gateway_arn" {
  description = "ARN of the Bedrock AgentCore Gateway"
  value       = aws_bedrockagentcore_gateway.gateway.gateway_arn
}

output "gateway_url" {
  description = "URL endpoint for the Bedrock AgentCore Gateway"
  value       = aws_bedrockagentcore_gateway.gateway.gateway_url
}

output "workload_identity_arn" {
  description = "Workload identity ARN for the Bedrock AgentCore Gateway"
  value       = try(aws_bedrockagentcore_gateway.gateway.workload_identity_details.workload_identity_arn, null)
}