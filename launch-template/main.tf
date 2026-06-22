resource "aws_launch_template" "template" {
  name                   = var.launch_template_name
  description            = var.description
  image_id               = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  user_data              = var.user_data
  update_default_version = var.update_default_version
  ebs_optimized          = var.ebs_optimized
  vpc_security_group_ids = var.vpc_security_group_ids

  dynamic "iam_instance_profile" {
    for_each = var.iam_instance_profile_name != null ? [var.iam_instance_profile_name] : []
    content {
      name = iam_instance_profile.value
    }
  }

  dynamic "block_device_mappings" {
    for_each = var.ebs_root_volume != null ? [var.ebs_root_volume] : []
    content {
      device_name = block_device_mappings.value.device_name

      ebs {
        volume_size           = block_device_mappings.value.volume_size
        volume_type           = block_device_mappings.value.volume_type
        delete_on_termination = block_device_mappings.value.delete_on_termination
        encrypted             = block_device_mappings.value.encrypted
      }
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.merged_tags
  }

  tags = local.merged_tags
}