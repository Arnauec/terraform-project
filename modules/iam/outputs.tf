output "iam_role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.iam_role.name
}

output "iam_policy_arn" {
  description = "The ARN of the attached IAM policy"
  value       = aws_iam_policy.s3_access_policy.arn
}
