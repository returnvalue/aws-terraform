# Lab 7: Remote State Architecture

**Goal:** Provision the S3 bucket and DynamoDB table required to safely share `terraform.tfstate` files in a collaborative team environment, preventing state corruption and enabling resource locking.

```hcl
# 1. Create backend_infrastructure.tf
resource "aws_s3_bucket" "terraform_state" {
  bucket = "portfolio-tf-state-backend"
}

resource "aws_s3_bucket_versioning" "state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "portfolio-tf-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
```

```bash
# 2. Apply the backend infrastructure
terraform apply -auto-approve
```

## 🧠 Key Concepts & Importance

- **Terraform State:** A file that maps your real-world resources to your configuration, keeps track of metadata, and improves performance for large infrastructures.
- **Remote State:** Storing the state file in a remote, shared location (like S3) rather than on your local machine. This is essential for teams to work on the same infrastructure.
- **State Locking:** DynamoDB is used to provide a locking mechanism. When one user is running `terraform apply`, Terraform locks the state so other users cannot make concurrent changes, preventing race conditions and state corruption.
- **Versioning:** Enabling versioning on the S3 bucket allows you to roll back to a previous state file if the current one becomes corrupted or a bad configuration is applied.
- **Backend Configuration:** Once this infrastructure is provisioned, you would configure a `terraform { backend "s3" { ... } }` block in your code to tell Terraform to use these specific resources for state management.

## 🛠️ Command Reference

- `terraform apply`: Provisions the S3 bucket and DynamoDB table. In a real-world scenario, this "bootstrap" step is often done manually or via a separate, simple Terraform configuration to create the foundation for the primary infrastructure.

---

💡 **Pro Tip: Using `aws` instead of `awslocal`**

If you prefer using the standard `aws` CLI without the `awslocal` wrapper or repeating the `--endpoint-url` flag, you can configure a dedicated profile in your AWS config files.

### 1. Configure your Profile
Add the following to your `~/.aws/config` file:
```ini
[profile localstack]
region = us-east-1
output = json
# This line redirects all commands for this profile to LocalStack
endpoint_url = http://localhost:4566
```

Add matching dummy credentials to your `~/.aws/credentials` file:
```ini
[localstack]
aws_access_key_id = test
aws_secret_access_key = test
```

### 2. Use it in your Terminal
You can now run commands in two ways:

**Option A: Pass the profile flag**
```bash
aws iam create-user --user-name DevUser --profile localstack
```

**Option B: Set an environment variable (Recommended)**
Set your profile once in your session, and all subsequent `aws` commands will automatically target LocalStack:
```bash
export AWS_PROFILE=localstack
aws iam create-user --user-name DevUser
```

### Why this works
- **Precedence**: The AWS CLI (v2) supports a global `endpoint_url` setting within a profile. When this is set, the CLI automatically redirects all API calls for that profile to your local container instead of the real AWS cloud.
- **Convenience**: This allows you to use the standard documentation commands exactly as written, which is helpful if you are copy-pasting examples from AWS labs or tutorials.
