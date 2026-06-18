resource "aws_iam_policy" "iam_policy" {
  name        = var.name
  path        = var.path
  description = var.description
  policy      = var.policy

  tags = local.merged_tags
}
