variable "pool_name" {
  type = string
}

variable "app_client_name" {
  type = string
}

variable "domain_prefix" {
  type    = string
  default = ""
}

variable "callback_urls" {
  type    = list(string)
  default = []
}

variable "logout_urls" {
  type    = list(string)
  default = []
}

variable "allowed_oauth_flows" {
  type    = list(string)
  default = ["code"]
}

variable "allowed_oauth_scopes" {
  type    = list(string)
  default = ["ALLOW_USER_PASSWORD_AUTH"]
  description = "List of authentication flows. The available options include ADMIN_NO_SRP_AUTH, CUSTOM_AUTH_FLOW_ONLY, USER_PASSWORD_AUTH, ALLOW_ADMIN_USER_PASSWORD_AUTH, ALLOW_CUSTOM_AUTH, ALLOW_USER_PASSWORD_AUTH, ALLOW_USER_SRP_AUTH, ALLOW_REFRESH_TOKEN_AUTH, and ALLOW_USER_AUTH."
}

variable "explicit_auth_flows" {
  type    = list(string)
  default = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
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
    Name             = var.pool_name
    Module           = "cognito-user-pool"
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
