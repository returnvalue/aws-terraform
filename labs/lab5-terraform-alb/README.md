# Lab 5: Advanced Networking (Load Balancers)

**Goal:** Provision an Application Load Balancer (ALB) and a Target Group. Terraform automatically handles the implicit dependencies, ensuring the VPC and Subnets exist before attempting to build the ALB.

```hcl
# 1. Create alb.tf
resource "aws_lb" "web_alb" {
  name               = "portfolio-web-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_subnet.id]
}

resource "aws_lb_target_group" "web_tg" {
  name     = "portfolio-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.portfolio_vpc.id
}
```

```bash
# 2. Apply the Load Balancer
tflocal apply -auto-approve
```

## 🧠 Key Concepts & Importance

- **Application Load Balancer (ALB):** A Layer 7 load balancer that routes traffic to targets (like EC2 instances) based on the content of the request.
- **Target Groups:** Used to route requests to one or more registered targets. You define health checks and protocols at the target group level.
- **Resource Graph:** Terraform builds a dependency graph of all resources. It identifies that the ALB depends on the Subnet, and the Target Group depends on the VPC.
- **Parallelism:** Terraform creates independent resources in parallel to speed up provisioning while ensuring that dependent resources are created in the correct order.
- **Infrastructure Complexity:** Provisioning an ALB manually involves many steps (creating the LB, TG, Listeners, etc.). Terraform allows you to define this entire stack in a few lines of code.

## 🛠️ Command Reference

- `apply`: Manages the complex lifecycle of the ALB and its associated components. Terraform ensures that the ALB is correctly attached to the specified subnets and VPC.
