# Lab 4: IAM & Security as Code

**Goal:** Provision an IAM Role and attach a custom policy to it. Doing this via IaC ensures your security posture is version-controlled, auditable, and consistently applied across environments.

```hcl
# 1. Create iam.tf to keep code organized
resource "aws_iam_role" "app_role" {
  name = "AppExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "s3_access" {
  name = "S3ReadAccess"
  role = aws_iam_role.app_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = ["s3:GetObject", "s3:ListBucket"]
      Effect = "Allow"
      Resource = "*"
    }]
  })
}
```

```bash
# 2. Apply the IAM changes
tflocal apply -auto-approve
```

## 🧠 Key Concepts & Importance

- **Security as Code:** Defining IAM roles, policies, and permissions in code allows you to treat security with the same rigor as application code—subjecting it to code reviews, testing, and versioning.
- **`jsonencode` Function:** A built-in Terraform function that converts a HCL object into a JSON string. This is the preferred way to define IAM policies as it prevents syntax errors and makes the code more readable.
- **Trust Policy (Assume Role):** The `assume_role_policy` defines which principal (e.g., an AWS service like EC2) is allowed to assume the role.
- **Inline vs. Managed Policies:** In this lab, we use `aws_iam_role_policy` (an inline policy). For reusable policies, you would use `aws_iam_policy` and `aws_iam_role_policy_attachment`.
- **Auditability:** Every change to your security configuration is recorded in your Git history, providing a clear trail of who changed what and when.

## 🛠️ Command Reference

- `apply`: Provisions the new IAM resources. Terraform calculates the necessary API calls to create the role and attach the policy.
