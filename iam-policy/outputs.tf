output "iam_policy_id" {
  description = "ID of the IAM policy"
  value       = aws_iam_policy.iam_policy.id
}

output "iam_policy_arn" {
  description = "ARN of the IAM policy"
  value       = aws_iam_policy.iam_policy.arn
}

output "iam_policy_name" {
  description = "Name of the IAM policy"
  value       = aws_iam_policy.iam_policy.name
}
