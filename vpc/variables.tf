variable "name" {
  type = string
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "availability_zone" {
  type = string
}

variable "endpoint_services" {
  type    = list(string)
  default = ["s3", "dynamodb"]
}

variable "environment" {
  type = string
}

variable "applicationid" {
  type = string
}

variable "applicationname" {
  type = string
}

variable "specifictags" {
  type    = map(string)
  default = {}
}

locals {
  common_tags = {
    Application_ID   = var.applicationid
    Application_Name = var.applicationname
    Environment      = var.environment
    Name             = var.name
    Module           = "vpc"
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
