resource "aws_acm_certificate" "certificate" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = var.validation_method
  key_algorithm             = var.key_algorithm
  certificate_transparency_logging_preference = var.certificate_transparency_logging_preference

  options {
    export = var.export
  }

  tags = local.merged_tags
}