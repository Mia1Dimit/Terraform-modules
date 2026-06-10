resource "aws_ecr_repository" "ecr_repository" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.encryption_type == "KMS" ? var.kms_key_arn : null
  }

  force_delete = var.force_delete
  tags         = local.merged_tags
}

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle_policy" {
  count = var.lifecycle_policy != null ? 1 : 0

  repository = aws_ecr_repository.ecr_repository.name
  policy     = var.lifecycle_policy
}

resource "aws_ecr_repository_policy" "ecr_repository_policy" {
  count = var.repository_policy != null ? 1 : 0

  repository = aws_ecr_repository.ecr_repository.name
  policy     = var.repository_policy
}
