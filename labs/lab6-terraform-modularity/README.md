# Lab 6: Modularity & Advanced State Routing (Native Terraform)

**Goal:** Create a reusable Terraform module that standardizes S3 bucket creation. To ensure reliable routing to our local environment, we will drop down to the native `terraform` CLI and enforce explicit endpoint targeting.

```hcl
# 1. Create the module (modules/secure_s3/main.tf)
variable "bucket_name" {}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 2. Call the module from the root directory (s3.tf)
module "app_data_bucket" {
  source      = "./modules/secure_s3"
  bucket_name = "portfolio-app-data-bucket-12345"
}
```

```bash
# 3. Clean up wrapper-generated overrides
rm -f 'localstack_providers_override.tf'

# 4. Target the LocalStack endpoint directly
export AWS_ENDPOINT_URL='http://localhost:4566'

# 5. Initialize using the NATIVE terraform CLI
terraform init

# 6. Apply using native Terraform
terraform apply -auto-approve
```

## 🧠 Key Concepts & Importance

- **Terraform Modules:** Reusable containers for multiple resources that are used together. Modules allow you to group resources into logical units and standardize configurations across your organization.
- **Dry (Don't Repeat Yourself):** Modules prevent code duplication. Instead of defining bucket versioning everywhere, you define it once in a "Secure S3" module and call it wherever needed.
- **Native CLI vs. Wrappers:** While `tflocal` is convenient, using the native `terraform` CLI with `AWS_ENDPOINT_URL` provides more control over how Terraform interacts with the AWS API, which is sometimes necessary for complex S3 routing logic.
- **Path-Style Addressing:** Local environments often require S3 to use path-style URLs (`http://localhost:4566/bucket`) rather than virtual-hosted style (`http://bucket.localhost:4566`). Native Terraform configuration allows for explicit control over these settings.
- **Module Source:** The `source` argument tells Terraform where to find the module code (local paths, Git URLs, or Terraform Registry).

## 🛠️ Command Reference

- `terraform init`: Initializes the directory and registers any new modules defined in the configuration.
- `terraform apply`: Provisions the resources defined in the root and any called modules.
- `export AWS_ENDPOINT_URL`: Sets a global environment variable that modern AWS SDKs and tools (including Terraform) use to redirect API calls to a custom endpoint like LocalStack.
