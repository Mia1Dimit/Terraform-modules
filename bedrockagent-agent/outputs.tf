output "agent_id" {
  description = "The unique identifier of the Bedrock agent"
  value       = aws_bedrockagent_agent.agent.agent_id
}

output "agent_arn" {
  description = "ARN of the Bedrock agent"
  value       = aws_bedrockagent_agent.agent.agent_arn
}

output "agent_name" {
  description = "The name of the Bedrock agent"
  value       = aws_bedrockagent_agent.agent.agent_name
}

output "agent_status" {
  description = "The current status of the Bedrock agent"
  value       = aws_bedrockagent_agent.agent.agent_status
}
