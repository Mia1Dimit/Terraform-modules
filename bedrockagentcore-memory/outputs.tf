output "memory_id" {
  description = "Unique identifier of the Bedrock AgentCore Memory"
  value       = aws_bedrockagentcore_memory.memory.id
}

output "memory_arn" {
  description = "ARN of the Bedrock AgentCore Memory"
  value       = aws_bedrockagentcore_memory.memory.arn
}