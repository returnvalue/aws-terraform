# Lab 2: Dynamic Data Sources & Compute

**Goal:** Avoid hardcoding specific resource IDs. We will use a `data` block to fetch a valid Amazon Linux 2 AMI dynamically and provision an EC2 instance into our previously created VPC.

```hcl
# Append to main.tf

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
# Apply the new resources
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
