variable "layer_name" {
  description = "The name of the Lambda layer."
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket where the layer zip is stored."
  type        = string
}

variable "s3_key" {
  description = "S3 key for the layer zip object."
  type        = string
}

variable "compatible_runtimes" {
  description = "List of runtimes compatible with this layer."
  type        = list(string)
  default     = ["python3.12"]
}

variable "compatible_architectures" {
  description = "Architectures compatible with this layer."
  type        = list(string)
  default     = ["arm64"]
}

variable "description" {
  description = "Description for the Lambda layer."
  type        = string
  default     = ""
}
