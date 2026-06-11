output "knowledge_base_id" {
  description = "The unique identifier of the Bedrock knowledge base"
  value       = aws_bedrockagent_knowledge_base.knowledge_base.knowledge_base_id
}

output "knowledge_base_arn" {
  description = "ARN of the Bedrock knowledge base"
  value       = aws_bedrockagent_knowledge_base.knowledge_base.knowledge_base_arn
}

output "knowledge_base_name" {
  description = "The name of the Bedrock knowledge base"
  value       = aws_bedrockagent_knowledge_base.knowledge_base.name
}

output "knowledge_base_status" {
  description = "The current status of the Bedrock knowledge base"
  value       = aws_bedrockagent_knowledge_base.knowledge_base.knowledge_base_status
}
