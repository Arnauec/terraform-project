# Define the Terraform backend (static for now)
terraform {
  backend "s3" {
    bucket         = "terraform-pet-project-bucket" # Shared bucket for state storage
    key            = "terraform/global/state"       # Placeholder for default key
    region         = "eu-central-1"                 # AWS region for the S3 bucket
    encrypt        = true                           # Ensure the state file is encrypted
  }
}

provider "aws" {
  region = "eu-central-1"
}
