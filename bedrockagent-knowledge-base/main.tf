resource "aws_bedrockagent_knowledge_base" "knowledge_base" {
  name              = var.knowledge_base_name
  role_arn          = var.role_arn
  knowledge_base_configuration {
    type = var.knowledge_base_type

    vector_knowledge_base_configuration {
      embedding_model_arn = var.embedding_model_arn

      dynamic "storage_configuration" {
        for_each = var.storage_configuration != null ? [var.storage_configuration] : []
        content {
          type = storage_configuration.value.type

          dynamic "opensearch_serverless_configuration" {
            for_each = lookup(storage_configuration.value, "opensearch_serverless_configuration", null) != null ? [storage_configuration.value.opensearch_serverless_configuration] : []
            content {
              collection_arn  = opensearch_serverless_configuration.value.collection_arn
              field_mapping {
                metadata_field = opensearch_serverless_configuration.value.field_mapping.metadata_field
                text_field     = opensearch_serverless_configuration.value.field_mapping.text_field
                vector_field   = opensearch_serverless_configuration.value.field_mapping.vector_field
              }
              vector_index_name = opensearch_serverless_configuration.value.vector_index_name
            }
          }

          dynamic "pinecone_configuration" {
            for_each = lookup(storage_configuration.value, "pinecone_configuration", null) != null ? [storage_configuration.value.pinecone_configuration] : []
            content {
              connection_string = pinecone_configuration.value.connection_string
              credentials_secret_arn = pinecone_configuration.value.credentials_secret_arn
              field_mapping {
                metadata_field = pinecone_configuration.value.field_mapping.metadata_field
                text_field     = pinecone_configuration.value.field_mapping.text_field
              }
              namespace = lookup(pinecone_configuration.value, "namespace", null)
            }
          }
        }
      }
    }
  }

  description                = var.description
  skip_resource_in_use_check = var.skip_resource_in_use_check
  tags                       = local.merged_tags
}
