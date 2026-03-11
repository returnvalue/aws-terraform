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
