variable "bucket_name" {
  description = "Base name of the bucket"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., dev, staging, prod)"
  type        = string
}

variable "path" {
  description = "The path for the bucket (e.g., auth, info, customers)"
  type        = string
}
