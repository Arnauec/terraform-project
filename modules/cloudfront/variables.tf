variable "bucket_domain_name" {
  description = "The domain name of the S3 bucket"
  type        = string
}

variable "origin_id" {
  description = "Origin ID for CloudFront"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., dev, staging, prod)"
  type        = string
}

variable "path" {
  description = "Path or purpose of the bucket (e.g., auth, info, customers)"
  type        = string
}
