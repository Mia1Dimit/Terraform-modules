variable "zone_id" {
  type        = string
  description = "Hosted zone ID where the record will be created"
}

variable "record_name" {
  type        = string
  description = "DNS record name"
}

variable "record_type" {
  type        = string
  description = "DNS record type (for example A, AAAA, CNAME, TXT)"
}

variable "ttl" {
  type        = number
  description = "TTL for non-alias records"
  default     = 300
}

variable "records" {
  type        = list(string)
  description = "Record values for non-alias records"
  default     = []
}

variable "alias_target" {
  type = object({
    name                   = string
    zone_id                = string
    evaluate_target_health = optional(bool, false)
  })
  description = "Alias target configuration for alias records"
  default     = null
}

variable "set_identifier" {
  type        = string
  description = "Set identifier for weighted, latency, failover, or geolocation records"
  default     = null
}

variable "health_check_id" {
  type        = string
  description = "Health check ID for the record"
  default     = null
}

variable "multivalue_answer_routing_policy" {
  type        = bool
  description = "Whether multivalue answer routing is enabled"
  default     = false
}

variable "allow_overwrite" {
  type        = bool
  description = "Allow Terraform to overwrite an existing record"
  default     = false
}