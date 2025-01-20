# Creates and configures an S3 bucket with versioning, encryption, and public access restrictions.
resource "aws_s3_bucket" "bucket" {
  # Dynamically generates the bucket name by combining the bucket name, environment, and path.
  bucket = "${var.bucket_name}-${var.environment}-${var.path}"

  # Tags provide metadata for better organization, cost tracking, and resource identification.
  tags = {
    Name        = "${var.bucket_name}-${var.environment}-${var.path}" # Unique name for the bucket based on environment and path.
    Environment = var.environment                                    # The environment where this bucket is used (e.g., dev, staging, prod).
    Path        = var.path                                           # The specific path (e.g., auth, info, customers).
  }
}

# Enables versioning on the S3 bucket.
resource "aws_s3_bucket_versioning" "bucket" {
  bucket = aws_s3_bucket.bucket.id # Links to the S3 bucket created above.

  versioning_configuration {
    status = "Enabled" # Ensures that multiple versions of objects are retained.
  }
}

# Configures public access blocking for the S3 bucket to prevent inadvertent exposure.
resource "aws_s3_bucket_public_access_block" "bucket" {
  bucket = aws_s3_bucket.bucket.id # Links to the S3 bucket created above.

  block_public_acls       = true # Blocks public access control lists (ACLs) for the bucket.
  block_public_policy     = true # Prevents public bucket policies from being applied.
  ignore_public_acls      = true # Ensures that any public ACLs are ignored.
  restrict_public_buckets = true # Restricts the bucket to only private objects and policies.
}

# Enables server-side encryption for the S3 bucket to protect data at rest.
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket" {
  bucket = aws_s3_bucket.bucket.id # Links to the S3 bucket created above.

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" # Uses AES256, the default S3 encryption algorithm.
    }
  }
}
