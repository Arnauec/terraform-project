output "auth_bucket_arn" {
  description = "ARN of the auth bucket for the current environment"
  value       = module.s3_auth.bucket_arn
}

output "info_bucket_arn" {
  description = "ARN of the info bucket for the current environment"
  value       = module.s3_info.bucket_arn
}

output "customers_bucket_arn" {
  description = "ARN of the customers bucket for the current environment"
  value       = module.s3_customers.bucket_arn
}

output "auth_bucket_name" {
  description = "Name of the auth bucket for the current environment"
  value       = module.s3_auth.bucket_name
}

output "info_bucket_name" {
  description = "Name of the info bucket for the current environment"
  value       = module.s3_info.bucket_name
}

output "customers_bucket_name" {
  description = "Name of the customers bucket for the current environment"
  value       = module.s3_customers.bucket_name
}

output "auth_iam_role_name" {
  description = "The name of the IAM role for the auth bucket"
  value       = module.iam_auth.iam_role_name
}

output "info_iam_role_name" {
  description = "The name of the IAM role for the info bucket"
  value       = module.iam_info.iam_role_name
}

output "customers_iam_role_name" {
  description = "The name of the IAM role for the customers bucket"
  value       = module.iam_customers.iam_role_name
}

output "auth_iam_policy_arn" {
  description = "The ARN of the IAM policy for the auth bucket"
  value       = module.iam_auth.iam_policy_arn
}

output "info_iam_policy_arn" {
  description = "The ARN of the IAM policy for the info bucket"
  value       = module.iam_info.iam_policy_arn
}

output "customers_iam_policy_arn" {
  description = "The ARN of the IAM policy for the customers bucket"
  value       = module.iam_customers.iam_policy_arn
}
