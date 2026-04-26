# Lab 3: Variables, Tfvars, and Outputs

**Goal:** Make the infrastructure code dynamic and reusable. We will separate our hardcoded instance size into a variable, override it using a `.tfvars` file, and output the resulting EC2 instance ID to the terminal so other tools (like CI/CD pipelines) can use it.
```hcl
# 1. Create variables.tf
variable "instance_type" {
  description = "The size of the EC2 instance"
  type        = string
  default     = "t2.micro"
}

# 2. Create terraform.tfvars
instance_type = "t3.small"

# 3. Refactor main.tf to use the variable
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  # ... other attributes
}

# 4. Create outputs.tf
output "web_server_id" {
  description = "The ID of the provisioned EC2 instance"
  value       = aws_instance.web_server.id
}
```
```bash
# 5. Apply the changes
tflocal apply -auto-approve
```

## 🧠 Key Concepts & Importance

- **Input Variables:** Serve as parameters for a Terraform module, allowing users to customize behavior without editing the source code.
- **Variable Precedence:** Terraform loads variables in a specific order: (1) environment variables, (2) `terraform.tfvars` file, (3) `*.auto.tfvars`, (4) command-line flags. `.tfvars` files are the standard way to manage environment-specific values.
- **Output Values:** Similar to return values in programming. They are used to highlight important information to the user or to pass data between different Terraform configurations.
- **Refactoring:** The process of restructuring existing code without changing its external behavior. Transitioning from hardcoded values to variables is a fundamental IaC refactoring step.
- **Dry (Don't Repeat Yourself):** Variables and modules help keep your code DRY, making it easier to maintain and less prone to copy-paste errors.

## 🛠️ Command Reference

- `apply`: Updates the real-world infrastructure. In this lab, it performs an in-place update of the instance type.
- `output`: (Implicitly used at the end of apply) Displays the values of output variables defined in the configuration.

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
