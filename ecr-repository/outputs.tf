output "repository_id" {
  description = "ID of the ECR repository"
  value       = aws_ecr_repository.ecr_repository.id
}

output "repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.ecr_repository.arn
}

output "repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.ecr_repository.name
}

output "repository_url" {
  description = "Repository URL to tag and push images"
  value       = aws_ecr_repository.ecr_repository.repository_url
}

output "registry_id" {
  description = "AWS account ID associated with the registry"
  value       = aws_ecr_repository.ecr_repository.registry_id
}
