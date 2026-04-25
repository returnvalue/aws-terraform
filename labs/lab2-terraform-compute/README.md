# Lab 2: Dynamic Data Sources & Compute

**Goal:** Never hardcode AMI IDs, as they change frequently and vary by region. We will use a `data` block to dynamically fetch the latest Amazon Linux 2 AMI, and provision an EC2 instance into our VPC.

```hcl
# 1. Append the Data Source and Compute configuration to main.tf
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "Terraform-Web-Server"
  }
}
```

```bash
# 2. Apply the new resources to create the EC2 instance
tflocal apply -auto-approve
```

## 🧠 Key Concepts & Importance

- **Data Sources:** Allow Terraform to use information defined outside of Terraform, or defined by another separate Terraform configuration. Here, we query the AWS API for the latest AMI ID.
- **Resource Dependency:** Terraform automatically handles dependencies between resources. Because `aws_instance.web_server` references `aws_subnet.public_subnet.id`, Terraform knows to create the subnet before the instance.
- **Implicit vs. Explicit Dependencies:** Referencing an attribute of another resource creates an *implicit* dependency. For complex scenarios, the `depends_on` meta-argument can create *explicit* dependencies.
- **Dynamic Configuration:** Using data sources makes your code portable across regions and accounts where ID values (like AMIs) might differ but names or patterns remain the same.

## 🛠️ Command Reference

- `apply`: Updates the real-world infrastructure to match the configuration file.
    - `-auto-approve`: Automatically applies the plan without asking for manual confirmation.

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
