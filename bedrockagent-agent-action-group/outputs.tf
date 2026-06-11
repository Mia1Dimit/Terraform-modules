output "action_group_id" {
  description = "Unique identifier of the action group"
  value       = aws_bedrockagent_agent_action_group.action_group.action_group_id
}

output "action_group_name" {
  description = "The name of the action group"
  value       = aws_bedrockagent_agent_action_group.action_group.action_group_name
}

output "agent_id" {
  description = "The agent ID that this action group is attached to"
  value       = aws_bedrockagent_agent_action_group.action_group.agent_id
}

output "agent_version" {
  description = "The agent version for this action group"
  value       = aws_bedrockagent_agent_action_group.action_group.agent_version
}
