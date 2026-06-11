resource "aws_bedrockagent_agent" "agent" {
  agent_name             = var.agent_name
  agent_resource_role_arn = var.agent_resource_role_arn
  foundation_model       = var.foundation_model
  description            = var.description

  idle_session_ttl_in_seconds = var.idle_session_ttl_in_seconds
  memory_configuration {
    max_tokens       = var.memory_max_tokens
    ttl_in_seconds   = var.memory_ttl_in_seconds
  }

  dynamic "guardrail_configuration" {
    for_each = var.guardrail_configuration != null ? [var.guardrail_configuration] : []
    content {
      guardrail_id      = guardrail_configuration.value.guardrail_id
      guardrail_version = lookup(guardrail_configuration.value, "guardrail_version", null)
    }
  }

  skip_resource_in_use_check = var.skip_resource_in_use_check
  tags                       = local.merged_tags
}
