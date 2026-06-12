resource "aws_sagemaker_notebook_instance" "sagemaker_notebook_instance" {
  name          = var.notebook_instance_name
  role_arn      = var.role_arn
  instance_type = var.instance_type

  platform_identifier = var.platform_identifier
  volume_size         = var.volume_size
  kms_key_id          = var.kms_key_id

  subnet_id            = var.subnet_id
  security_groups      = var.security_group_ids
  direct_internet_access = var.direct_internet_access

  root_access          = var.root_access
  lifecycle_config_name = var.lifecycle_config_name
  default_code_repository = var.default_code_repository
  additional_code_repositories = var.additional_code_repositories

  accelerator_types = var.accelerator_types

  tags = local.merged_tags
}
