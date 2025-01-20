# Creates an IAM role, policies, and attachments to securely grant CloudFront access to an S3 bucket.

# IAM Role: Allows CloudFront to assume this role to access the S3 bucket.
resource "aws_iam_role" "iam_role" {
  name               = "${var.role_name}-${var.environment}" # Dynamically names the role based on the environment (e.g., "cloudfront-auth-role-dev").
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json # Trust policy for the role, defined below.
}

# IAM Trust Policy: Specifies the trusted entity (CloudFront) that can assume this role.
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"] # Allows CloudFront to assume this role.

    # Specifies the principal (trusted entity) allowed to assume the role.
    principals {
      type        = "Service"                  # Indicates this is an AWS service principal.
      identifiers = ["cloudfront.amazonaws.com"] # Trust relationship with CloudFront.
    }
  }
}

# IAM Policy: Defines the permissions that CloudFront will have when assuming this role.
resource "aws_iam_policy" "s3_access_policy" {
  name        = "${var.policy_name}-${var.environment}" # Dynamically names the policy based on the environment (e.g., "s3_access_policy-dev").
  description = "S3 access policy for ${var.path} in ${var.environment} environment" # Describes the purpose of the policy.

  # The actual policy document, defined below.
  policy = data.aws_iam_policy_document.s3_policy.json
}

# S3 Policy Document: Grants CloudFront permission to read objects from the specified S3 bucket.
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"] # Grants read-only access to objects in the S3 bucket.

    # Restricts the policy to a specific bucket and all its objects.
    resources = ["arn:aws:s3:::${var.bucket_name}/*"] # Dynamically references the bucket ARN passed via variables.

    effect = "Allow" # Specifies that this action is allowed.
  }
}

# IAM Role Policy Attachment: Attaches the S3 access policy to the IAM role.
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.iam_role.name           # The name of the IAM role to which the policy is attached.
  policy_arn = aws_iam_policy.s3_access_policy.arn  # The ARN of the policy being attached.
}
