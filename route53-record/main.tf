resource "aws_route53_record" "record" {
  zone_id = var.zone_id
  name    = var.record_name
  type    = var.record_type
  ttl     = var.alias_target == null ? var.ttl : null
  records = var.alias_target == null ? var.records : null

  set_identifier                   = var.set_identifier
  health_check_id                  = var.health_check_id
  multivalue_answer_routing_policy = var.multivalue_answer_routing_policy
  allow_overwrite                  = var.allow_overwrite

  dynamic "alias" {
    for_each = var.alias_target != null ? [var.alias_target] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }
}