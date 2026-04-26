# Lab 1: Provider Setup & Foundational Networking

**Goal:** Define the AWS provider, initialize the working directory, and create a custom VPC and Subnet using declarative configuration.
```hcl
# 1. Create the main configuration file (main.tf)
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "portfolio_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "Portfolio-VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.portfolio_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "Portfolio-Public-Subnet"
  }
}
```
```bash
# 2. Initialize the Terraform working directory
tflocal init

# 3. Apply the configuration to provision the resources
tflocal apply -auto-approve
```

## 🧠 Key Concepts & Importance

- **Infrastructure as Code (IaC):** The process of managing and provisioning computer data centers through machine-readable definition files, rather than physical hardware configuration or interactive configuration tools.
- **Provider:** Terraform relies on plugins called providers to interact with remote systems (in this case, AWS via LocalStack).
- **Resources:** The most important element in the Terraform language. Each resource block describes one or more infrastructure objects, such as a VPC or Subnet.
- **Declarative vs. Imperative:** Terraform is declarative; you describe the *end state* you want, and Terraform figures out how to achieve it.
- **Initialization:** The `init` command downloads the necessary provider plugins and prepares the directory for use.

## 🛠️ Command Reference

- `init`: Initializes a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration.
- `apply`: Executes the actions proposed in a Terraform plan to create, update, or destroy infrastructure.
    - `-auto-approve`: Skips the interactive prompt for confirmation before applying changes.

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
