variable "instance_name" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "iam_instance_profile" {
  type    = string
  default = null
}

variable "user_data" {
  type    = string
  default = null
}

variable "associate_public_ip" {
  type    = bool
  default = true
}

variable "ebs_volume_size" {
  type    = number
  default = 20
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
    Name             = var.instance_name
    Module           = "ec2-instance"
  }
  merged_tags = merge(local.common_tags, var.specifictags)
}
