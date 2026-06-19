resource "aws_bedrockagentcore_gateway" "gateway" {
  name            = var.gateway_name
  role_arn        = var.role_arn
  authorizer_type = var.authorizer_type

  description     = var.description
  exception_level = var.exception_level
  kms_key_arn     = var.kms_key_arn
  protocol_type   = var.protocol_type

  dynamic "authorizer_configuration" {
    for_each = var.authorizer_type == "CUSTOM_JWT" && var.custom_jwt_authorizer != null ? [var.custom_jwt_authorizer] : []
    content {
      custom_jwt_authorizer {
        discovery_url    = authorizer_configuration.value.discovery_url
        allowed_audience = authorizer_configuration.value.allowed_audience
        allowed_clients  = authorizer_configuration.value.allowed_clients
        allowed_scopes   = authorizer_configuration.value.allowed_scopes
      }
    }
  }

  dynamic "protocol_configuration" {
    for_each = var.protocol_type == "MCP" && var.mcp_protocol_configuration != null ? [var.mcp_protocol_configuration] : []
    content {
      mcp {
        instructions       = protocol_configuration.value.instructions
        search_type        = protocol_configuration.value.search_type
        supported_versions = protocol_configuration.value.supported_versions

        dynamic "session_configuration" {
          for_each = protocol_configuration.value.session_timeout_in_seconds != null ? [protocol_configuration.value.session_timeout_in_seconds] : []
          content {
            session_timeout_in_seconds = session_configuration.value
          }
        }

        dynamic "streaming_configuration" {
          for_each = protocol_configuration.value.enable_response_streaming != null ? [protocol_configuration.value.enable_response_streaming] : []
          content {
            enable_response_streaming = streaming_configuration.value
          }
        }
      }
    }
  }

  tags = local.merged_tags
}