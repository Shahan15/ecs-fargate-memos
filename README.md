# ECS Fargate Memos App

This project delivers a production-grade, end-to-end deployment of a privacy-focused memo application on Amazon Web Services using Amazon ECS Fargate. It utilises Docker for containerisation, Terraform for infrastructure as code, and GitHub Actions to automate both infrastructure provisioning and application delivery. The solution is designed to be secure, scalable, and production-ready, incorporating HTTPS encryption, persistent storage for .tfstates, and a fully automated CI/CD pipeline to ensure consistent and repeatable deployments.

## Overview

Containerisation: Multi-stage builds using `scratch` base image to reduce image size to ~30MB
Infrastructre as Code (IaC): Terraform manages all infrastructure, fully automated
Compute: AWS ECS Fargate
Networking: Custom VPC, Private/Public Subnets Alongside NAT Gateways, Routes, Security Groups, Load Balancing
TLS/DNS: SSL Certifcation configured via ACM, DNS (Cloudflare)
CI/CD: Builds Image, pushes to ECR and updates ECS, Automated Unit Tests, Automated IaC deployment.
Registry: Docker image hosted in AWS ECR

## Demo





## Architecture

![Architecture Diagram](<assets/Architecture Diagram.png>)

**Traffic flow:**

```
User --> queries Route53 (memos.shahankhan.co.uk) --> Route53 resolves to ALB --> ALB redirects any HTTP(port 80) traffic to HTTPS(Port 443) --> ALB directs traffic to Target Group (ECS Fargate Task)
```

| Design Decision                           | Rationale                                                                                                                      |
| :---------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------- |
| **Compute: ECS Fargate**                  | Provides serverless container orchestration, removing the operational overhead of managing EC2 instances.                      |
| **IaC: Terraform**                        | Ensures idempotenecy, ensures reproducible infrastructure and automated state management.                                      |
| **State Management: S3 + Native Locking** | S3 used for `.tfstate` locking (`use_lockfile = true`), eliminating the need for external database dependencies like DynamoDB. |
| **All traffic handled by ALB**            | Provides SSL/TSL Termination, High availability, Allows ECS tasks to be completely isolated.                                   |
| **Network: Public/Private VPC**           | Ensures secure application isolation by placing ECS tasks in private subnets with controlled NAT gateway access.               |

### Project Structure

```
memos-infra/
├── .github/
│   └── workflows/
│       ├── docker-buildPush.yml
│       ├── terraformDeploy.yml
│       └── unittests.yml
├── app/                    # Memos application source/config
├── infra/                  # Terraform infrastructure code
│   ├── modules/            # Reusable resource modules
│   │   ├── alb/            # Load Balancer configuration
│   │   ├── ecs/            # Fargate task and service definitions
│   │   ├── iam/            # IAM roles and execution policies
│   │   ├── route53/        # DNS record management
│   │   ├── sg/             # Security Group rules
│   │   └── vpc/            # Networking and subnet architecture
│   ├── main.tf             # Root infrastructure entry point
│   ├── output.tf           # Infrastructure outputs
│   ├── providers.tf        # AWS provider and backend configuration
│   ├── variables.tf        # Input variable definitions
│   └── terraform.example.tfvars #Example of .tfvars file required
├── infra-prereq/           # Pre-deployment setup scripts
├── Dockerfile              # Container definition for Memos
├── docker-compose.yml      # Local development orchestration
├── .dockerignore
├── .gitignore
└── README.md
```

## Local Setup (Quick start)

**Prerequisites:** Docker

```
docker build -t memos . #To build image
```

![Docker Build Command](assets/docker_Build_LocalSetup.png)

```
docker run -p 5230:5230 memos #Start the Container
```

![Docker Run Command](assets/docker_Run_LocalSetup.png)

You can run a health check via:
`curl http://localhost:5230/healthCheck`

![Health Check](assets/health_check.png)

Open `http://localhost:5230` and start writing!

## Infrastructure
**Custom VPC:** Consisting of 2 public subnets and 2 Private subnets across 2 AZ's. Ensuring high availability.

**Internet Gateway + NAT Gateway:** Internet gateway enabling bidrectional traffic, with NAT Gateway providing secure outbound access for private subnets.

**Route53:** Provides DNS Resolution for domain `(memos.shahankhan.co.uk)` to ALB via Alias record

**Application Load Balancer:** Handles all traffic into VPC on port 80/443. Handles SSL/TLS Termination and redirects HTTP traffic to HTTPS. Provisoned across subnets in AZ's. SSL/TLS Cert handled by AWS ACM. Moving traffic to appropriate target group

**ECS/Fargate:**Serverless container orchestration. Provisoned across multiple AZ's ensuring high avialability.

**S3 Bucket:** `.tfstate` is stored in secure S3 bucket with native locking enabled. Ensuring idempotency and and prevent concurrent modification by multiple users or processes.








