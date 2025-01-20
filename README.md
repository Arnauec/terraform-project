# AWS Infra with Terraform

Hey there! 👋 This is a small personal project where I’m using Terraform to set up some AWS infra for hosting static content. The goal is to make it organized, reusable, and secure across three different environments: `dev`, `staging`, and `prod`. It’s nothing too fancy but gets the job done!

The setup includes:
- S3 buckets for storing static files.
- CloudFront distributions for fast and secure content delivery.
- IAM roles and policies to ensure secure and least-privilege access to the S3 buckets.

---

## What’s in this repo?

Here’s what you get with this setup:

1. **Three environments**:
    - `dev`, `staging`, and `prod`.
2. **Three S3 buckets per environment**:
    - One bucket for `/auth`.
    - Another for `/info`.
    - And another for `/customers`.
3. **One CloudFront distribution per bucket**:
    - Ensures files are served globally, securely, and with caching.
4. **IAM roles and policies**:
    - Grants secure, least-privilege access for CloudFront to read objects from S3 buckets.
5. **Security features**:
    - All S3 buckets are encrypted with AES-256, private, and versioned.

---

## How I organized the files

The project is modular and easy to maintain. Each module handles a specific responsibility (S3, CloudFront, IAM). The configuration is flexible and reusable for multiple environments.

```  
terraform-aws-infra/
├── modules/
│ ├── s3/           # S3 bucket configuration (encryption, versioning, public access blocking)
│ ├── cloudfront/   # CloudFront distribution setup
│ ├── iam/          # IAM roles and policies for secure access
├── envs/
│ ├── dev/          # Environment-specific configuration for dev
│ ├── staging/      # Environment-specific configuration for staging
│ └── prod/         # Environment-specific configuration for prod
├── variables.tf    # Global variables
├── outputs.tf      # Outputs for S3, CloudFront, and IAM
├── provider.tf     # Backend and provider configuration
├── main.tf  
└── README.md       # This file!
```

---

### **Modules**

- **S3**:
    - Creates S3 buckets with encryption, versioning, and public access restrictions.
    - Buckets are dynamically named based on the `%60bucket_name%60`, `%60environment%60`, and `%60path%60` variables (e.g., `%60bucket1-dev-auth%60`).
- **CloudFront**:
    - Configures CloudFront distributions to serve content from the S3 buckets.
    - Uses default SSL certificates for HTTPS and sets caching policies for performance.
- **IAM**:
    - Creates IAM roles and policies to allow CloudFront to securely access S3 buckets.
    - Follows the principle of least privilege by granting only `%60s3:GetObject%60` permissions.

---

## Environments

The `envs/` folder contains configurations for each environment. These configurations use the modules to create resources specific to `dev`, `staging`, or `prod`.

Example `tfvars` files for the environments:

### **dev.tfvars**
```hcl  
environment = "dev"  
bucket_name = "bucket1"  
path        = "auth"  
```

### **staging.tfvars**
```hcl  
environment = "staging"  
bucket_name = "bucket1"  
path        = "auth"  
```

### **prod.tfvars**
```hcl  
environment = "prod"  
bucket_name = "bucket1"  
path        = "auth"  
```

---

## How to run this

Here’s how to deploy it yourself:

1. **Clone the repo**:  
   ```bash  
   git clone https://github.com/yourusername/terraform-aws-infra.git  
   cd terraform-aws-infra  
   ```

2. **Create a bucket for Terraform state**:  
   ```bash  
   aws s3api create-bucket --bucket terraform-pet-project-bucket --region eu-central-1 --create-bucket-configuration LocationConstraint=eu-central-1  
   ```

3. **Initialize Terraform**:  
   ```bash  
   terraform init -backend-config=envs/{env}/{env}-backend.conf --reconfigure

   ```

4. **Set the variables**:  
   Use a `tfvars` file for each environment (e.g., `dev.tfvars`).

5. **Plan and apply the changes**:
    - To preview changes:
      ```bash  
      terraform plan -var-file=./envs/{env}/{env}.tfvars
      ```
    - To apply the changes:
      ```bash  
      terraform apply -var-file=./envs/{env}/{env}.tfvars
      ```

6. **Clean up resources** (when you're done):
    - To destroy everything:
      ```bash  
      terraform destroy -var-file=./envs/{env}/{env}.tfvars
      ```

---

## Security Features

Here’s what I did to keep things secure:
1. **S3 Buckets**:
    - All buckets are private by default.
    - AES-256 encryption ensures data is secure at rest.
    - Versioning is enabled to prevent accidental data loss.
    - Public access is completely blocked using `aws_s3_bucket_public_access_block`.

2. **IAM Roles and Policies**:
    - Each CloudFront distribution gets a dedicated IAM role.
    - The roles are granted least-privilege `s3:GetObject` permissions for their respective buckets.

3. **CloudFront**:
    - Enforces HTTPS for secure communication.
    - Uses default SSL certificates for encryption in transit.

---

## What’s next?

Here are some ideas to improve this project further:
- **Enable logging**:
    - S3 bucket access logs and CloudFront logs for operational visibility and troubleshooting.
- **Add CI/CD**:
    - Automate deployments with GitHub Actions or AWS CodePipeline.
- **Web Application Firewall (WAF)**:
    - Protect CloudFront distributions with WAF for enhanced security.
- **Custom SSL Certificates**:
    - Use AWS Certificate Manager to add domain-specific SSL certificates.

---

## Outputs

When you apply the Terraform code, you’ll get:
- **S3 Bucket ARNs**: Useful for troubleshooting and IAM policies.
- **CloudFront Distribution URLs**: The URLs for accessing your static content.
- **IAM Role Names**: For auditing and verification.

---

## License

Feel free to use this however you want! No strings attached. 😊
