# Creates and configures resources for the "auth", "info", and "customers" paths in the environment.
# Each path has its own S3 bucket, CloudFront distribution, and IAM role/policy for secure access.

# S3 Module: Creates an S3 bucket for the "auth" path.
module "s3_auth" {
  source      = "./modules/s3"                                           # Path to the S3 module.
  bucket_name = "bucket1"                                                # Name of the bucket (dynamic suffix added in the module).
  environment = var.environment                                          # Environment (e.g., dev, staging, prod) passed as a variable.
  path        = "auth"                                                   # Specifies the path (auth, info, or customers).
}

# S3 Module: Creates an S3 bucket for the "info" path.
module "s3_info" {
  source      = "./modules/s3"                                           # Path to the S3 module.
  bucket_name = "bucket2"                                                # Name of the bucket (dynamic suffix added in the module).
  environment = var.environment                                          # Environment (e.g., dev, staging, prod) passed as a variable.
  path        = "info"                                                   # Specifies the path (auth, info, or customers).
}

# S3 Module: Creates an S3 bucket for the "customers" path.
module "s3_customers" {
  source      = "./modules/s3"                                          # Path to the S3 module.
  bucket_name = "bucket3"                                               # Name of the bucket (dynamic suffix added in the module).
  environment = var.environment                                         # Environment (e.g., dev, staging, prod) passed as a variable.
  path        = "customers"                                             # Specifies the path (auth, info, or customers).
}

# CloudFront Module: Configures a CloudFront distribution for the "auth" S3 bucket.
module "cloudfront_auth" {
  source             = "./modules/cloudfront"                           # Path to the CloudFront module.
  bucket_domain_name = module.s3_auth.bucket_regional_domain_name       # Uses the bucket name created by the "s3_auth" module as the origin.
  origin_id          = "auth-origin"                                    # A unique identifier for the origin (S3 bucket).
  environment        = var.environment                                  # Environment (e.g., dev, staging, prod) passed as a variable.
  path               = "auth"                                           # Specifies the path for this distribution.
}

# CloudFront Module: Configures a CloudFront distribution for the "info" S3 bucket.
module "cloudfront_info" {
  source             = "./modules/cloudfront"                           # Path to the CloudFront module.
  bucket_domain_name = module.s3_info.bucket_regional_domain_name       # Uses the bucket name created by the "s3_info" module as the origin.
  origin_id          = "info-origin"                                    # A unique identifier for the origin (S3 bucket).
  environment        = var.environment                                  # Environment (e.g., dev, staging, prod) passed as a variable.
  path               = "info"                                           # Specifies the path for this distribution.
}

# CloudFront Module: Configures a CloudFront distribution for the "customers" S3 bucket.
module "cloudfront_customers" {
  source             = "./modules/cloudfront"                           # Path to the CloudFront module.
  bucket_domain_name = module.s3_customers.bucket_regional_domain_name  # Uses the bucket name created by the "s3_customers" module as the origin.
  origin_id          = "customers-origin"                               # A unique identifier for the origin (S3 bucket).
  environment        = var.environment                                  # Environment (e.g., dev, staging, prod) passed as a variable.
  path               = "customers"                                      # Specifies the path for this distribution.
}

# IAM Module: Creates an IAM role and policy for CloudFront to access the "auth" S3 bucket.
module "iam_auth" {
  source      = "./modules/iam"                                         # Path to the IAM module.
  role_name   = "cloudfront-auth-role"                                  # Name of the IAM role for the "auth" bucket.
  policy_name = "cloudfront-auth-policy"                                # Name of the IAM policy for the "auth" bucket.
  bucket_name = module.s3_auth.bucket_name                              # Uses the bucket name created by the "s3_auth" module.
  path        = "auth"                                                  # Specifies the path for this IAM configuration.
  environment = var.environment                                         # Environment (e.g., dev, staging, prod) passed as a variable.
}

# IAM Module: Creates an IAM role and policy for CloudFront to access the "info" S3 bucket.
module "iam_info" {
  source      = "./modules/iam"                                         # Path to the IAM module.
  role_name   = "cloudfront-info-role"                                  # Name of the IAM role for the "info" bucket.
  policy_name = "cloudfront-info-policy"                                # Name of the IAM policy for the "info" bucket.
  bucket_name = module.s3_info.bucket_name                              # Uses the bucket name created by the "s3_info" module.
  path        = "info"                                                  # Specifies the path for this IAM configuration.
  environment = var.environment                                         # Environment (e.g., dev, staging, prod) passed as a variable.
}

# IAM Module: Creates an IAM role and policy for CloudFront to access the "customers" S3 bucket.
module "iam_customers" {
  source      = "./modules/iam"                                         # Path to the IAM module.
  role_name   = "cloudfront-customers-role"                             # Name of the IAM role for the "customers" bucket.
  policy_name = "cloudfront-customers-policy"                           # Name of the IAM policy for the "customers" bucket.
  bucket_name = module.s3_customers.bucket_name                         # Uses the bucket name created by the "s3_customers" module.
  path        = "customers"                                             # Specifies the path for this IAM configuration.
  environment = var.environment                                         # Environment (e.g., dev, staging, prod) passed as a variable.
}
