resource "aws_bedrockagent_agent_action_group" "action_group" {
  action_group_name  = var.action_group_name
  agent_id           = var.agent_id
  agent_version      = var.agent_version
  action_group_state = var.action_group_state

  action_group_executor {
    lambda = var.lambda_arn
  }

  dynamic "api_schema" {
    for_each = var.api_schema_payload != null || var.api_schema_s3 != null ? [1] : []
    content {
      payload = var.api_schema_payload

      dynamic "s3" {
        for_each = var.api_schema_s3 != null ? [var.api_schema_s3] : []
        content {
          s3_bucket_name = s3.value.bucket_name
          s3_object_key  = s3.value.object_key
        }
      }
    }
  }

  dynamic "function_schema" {
    for_each = var.function_schema != null ? [var.function_schema] : []
    content {
      member_functions {
        dynamic "functions" {
          for_each = function_schema.value.functions != null ? function_schema.value.functions : []
          content {
            name        = functions.value.name
            description = lookup(functions.value, "description", null)

            dynamic "parameters" {
              for_each = lookup(functions.value, "parameters", {})
              content {
                map_block_key = parameters.key
                type          = parameters.value.type
                description   = lookup(parameters.value, "description", null)
                required      = lookup(parameters.value, "required", false)
              }
            }
          }
        }
      }
    }
  }

  description                = var.description
  skip_resource_in_use_check = var.skip_resource_in_use_check
  prepare_agent              = var.prepare_agent
}
