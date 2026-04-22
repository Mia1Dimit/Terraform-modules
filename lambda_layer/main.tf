resource "aws_lambda_layer_version" "layer" {
  layer_name               = var.layer_name
  s3_bucket                = var.s3_bucket
  s3_key                   = var.s3_key
  compatible_runtimes      = var.compatible_runtimes
  compatible_architectures = var.compatible_architectures
  description              = var.description

  lifecycle { ignore_changes = [s3_key] }
}
