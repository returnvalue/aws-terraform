# AWS Infrastructure as Code (Terraform) Labs (LocalStack Pro)

![AWS](https://img.shields.io/badge/AWS-Infrastructure_as_Code-FF9900?style=for-the-badge&logo=amazonaws)
![LocalStack](https://img.shields.io/badge/LocalStack-Pro-000000?style=for-the-badge)

This repository contains hands-on labs demonstrating core Infrastructure as Code (IaC) concepts using HashiCorp Terraform. Using [LocalStack Pro](https://localstack.cloud/) and the `tflocal` wrapper, we simulate a complete AWS environment to practice declarative resource provisioning, state management, and modular design.

## 🎯 Architecture Goals & Use Cases Covered
Based on AWS best practices (SAA-C03), these labs cover:
* **Declarative Provisioning:** Defining infrastructure as code to ensure consistency and repeatability.
* **Dynamic Lookups:** Using Data Sources to fetch AMIs and other external information.
* **Variables & Outputs:** Making configurations dynamic, reusable, and extractable.
* **Security as Code:** Managing IAM roles and policies via version-controlled HCL.
* **Compute Management:** Provisioning and modifying EC2 instances via code.
* **Advanced Networking:** Deploying Application Load Balancers and Target Groups.
* **Modular Design:** Organizing resources into reusable, standardized modules.
* **Networking Foundation:** Designing VPCs and Subnets via code.
* **State Management:** Implementing remote state storage and locking via S3 and DynamoDB.

## ⚙️ Prerequisites

* [Docker](https://docs.docker.com/get-docker/) & Docker Compose
* [LocalStack Pro](https://app.localstack.cloud/) account and Auth Token
* [Terraform](https://developer.hashicorp.com/terraform/downloads) installed locally
* [`tflocal` CLI](https://github.com/localstack/terraform-local) (a wrapper around Terraform for LocalStack)

## 🚀 Environment Setup

1. Configure your LocalStack Auth Token in `.env`:
   ```bash
   echo "YOUR_TOKEN=your_auth_token_here" > .env
   ```

2. Start LocalStack Pro:
   ```bash
   docker-compose up -d
   ```

> [!IMPORTANT]
> **Cumulative Architecture:** These labs are designed as a cumulative scenario. You are building an evolving infrastructure stack.

## 📚 Labs Index
1. [Lab 1: Provider Setup & Foundational Networking](./labs/lab1-terraform-foundation/README.md)
2. [Lab 2: Dynamic Data Sources & Compute](./labs/lab2-terraform-compute/README.md)
3. [Lab 3: Variables, Tfvars, and Outputs](./labs/lab3-terraform-variables/README.md)
4. [Lab 4: IAM & Security as Code](./labs/lab4-terraform-iam/README.md)
5. [Lab 5: Advanced Networking (Load Balancers)](./labs/lab5-terraform-alb/README.md)
6. [Lab 6: Modularity & Advanced State Routing (Native Terraform)](./labs/lab6-terraform-modularity/README.md)
7. [Lab 7: Remote State Architecture](./labs/lab7-terraform-state/README.md)
