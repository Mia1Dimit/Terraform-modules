variable "knowledge_base_name" {
  type        = string
  description = "Name of the Bedrock knowledge base"
}

variable "role_arn" {
  type        = string
  description = "ARN of the IAM role that the knowledge base uses to interact with other AWS services"
}

variable "knowledge_base_type" {
  type        = string
  default     = "VECTOR"
  description = "Type of knowledge base. Valid values: VECTOR"
}

variable "embedding_model_arn" {
  type        = string
  description = "ARN of the embedding model to use for the knowledge base"
  default     = "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-embed-text-v1"
}

variable "storage_configuration" {
  type = object({
    type = string
    opensearch_serverless_configuration = optional(object({
      collection_arn = string
      field_mapping = object({
        metadata_field = string
        text_field     = string
        vector_field   = string
      })
      vector_index_name = string
    }))
    pinecone_configuration = optional(object({
      connection_string       = string
      credentials_secret_arn  = string
      field_mapping = object({
        metadata_field = string
        text_field     = string
      })
      namespace = optional(string)
    }))
  })
  description = "Storage configuration for the knowledge base. Supports OpenSearch Serverless or Pinecone"
}

variable "description" {
  type        = string
  default     = null
  description = "Description of the Bedrock knowledge base"
}

variable "skip_resource_in_use_check" {
  type        = bool
  default     = false
  description = "Whether to skip the resource in-use check during deletion"
}

variable "environment" {
  type        = string
  description = "Environment Tag"
}

variable "applicationid" {
  type        = string
  description = "Application_ID Tag"
}

variable "applicationname" {
  type        = string
  description = "Application_Name Tag"
}

variable "name" {
  type        = string
  description = "Name for the knowledge base"
}

variable "purpose" {
  type        = string
  description = "Purpose of the knowledge base"
  default     = "RAG Knowledge Base"
}

variable "specifictags" {
  type        = map(string)
  description = "Specific tags for the resource"
  default     = {}
}

locals {
  common_tags = {
    Application_ID   = var.applicationid
    Application_Name = var.applicationname
    Environment      = var.environment
    Name             = var.name
    Module           = "bedrockagent-knowledge-base"
    Purpose          = var.purpose
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
