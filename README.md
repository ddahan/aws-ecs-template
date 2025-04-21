# Nuxt 3 + FastAPI Dockerized App on AWS ECS

This document provides a full overview of the architecture, infrastructure, and deployment pipeline used for this project: a modern Dockerized web app with Nuxt 3 frontend and FastAPI backend, deployed to AWS using ECS Fargate, ECR, ALB, and ACM.

## 🚀 Stack Overview

- **Frontend**: Nuxt 3 (static mode, served by Nginx)
- **Backend**: FastAPI (served with Uvicorn)
- **Database**: PostgreSQL (local only for now)
- **Dockerized**: Yes (frontend & backend)
- **AWS Services**:
  - ECS (Elastic Container Service) Fargate
  - ECR (Elastic Container Registery)
  - ALB (Application Load Balancer)
  - ACM (AWS Certificate Manager)
  - OVH DNS (with `walt.ovh` domain)

## 🔧 Local Setup

**Installation Instructions**

1. Make sure Docker and Docker Compose are installed.
2. Clone the repository.
3. From the project root, run `docker compose -f docker-compose.local.yml up --build`

This will:
- Build the frontend and backend containers
- Start services on:
  - Frontend: http://localhost:3000
  - Backend: http://localhost:8000

## ☁️ AWS Infrastructure

### ✅ ECS
- Cluster: `my-cluster`
- Services: `front-service`, `back-service`
- Task definitions: `front-task`, `back-task`

### ✅ ECR
- Repositories: `front`, `back`

### ✅ ALB (public facing)
- `front-alb` with target group `front-tg`
- `back-alb` with target group `back-tg`

### ✅ ACM
- Certificate for both subdomains (validated by DNS)

### ✅ VPC
- Default VPC

### ✅ IAM
- User: `github-actions`
- Policies:
  - `AmazonEC2ContainerRegistryPowerUser`
  - `AmazonECSFullAccess`

### ✅ DNS (OVH, not AWS)

- CNAME entries:
  - ecs-front.walt.ovh → front-alb-XYZ.elb.amazonaws.com.
  - ecs-back.walt.ovh → back-alb-XYZ.elb.amazonaws.com.

## 🔄 Deployment Workflow (CI)

### GitHub Actions (`deploy.yml`):
On push to `main`:
1. Builds and pushes backend Docker image to ECR
2. Builds and pushes frontend Docker image with build-time `NUXT_API_BASE`
3. Tags both images with `${{ github.sha }}` and `latest`

> Auto deployment via ECS has been disabled for now.

### 🔐 GitHub Secrets
These values must be defined in your repository’s GitHub Actions Secrets section:

| Secret Name              | Description                                             |
|--------------------------|---------------------------------------------------------|
| `AWS_ACCESS_KEY_ID`      | IAM user’s access key                                   |
| `AWS_SECRET_ACCESS_KEY`  | IAM user’s secret access key                            |
| `ECR_FRONT_URI`          | Full URI of the frontend ECR repo (e.g. `1234.dkr.ecr...`) |
| `ECR_BACK_URI`           | Full URI of the backend ECR repo                        |
| `NUXT_API_BASE`          | Backend base URL used at build time (e.g. `https://ecs-back.walt.ovh`) |


### ✅ Manual Deployment

To deploy a new image:

1. Go to ECS > Task Definitions.
2. Create a new revision of the task (e.g. front-task, back-task), updating the image URI (use :latest or Git SHA).
3. Then go to ECS > Services and:
  - Select your service (e.g. front-service)
  - Click Update → Force new deployment → use latest task definition revision
  - Confirm and wait for health checks to pass

## 🧼 To Recreate

- Use default VPC with public subnets in region eu-west-3
- Create ECR repos front, back
- Push Docker images
- Set up ACM cert with both subdomains
- Create ALBs and target groups
- Create ECS services (with public IPs + ALB routing)
- Point OVH DNS (CNAME) to ALBs

# Todos
- [ ] Add doc
- [ ] Add draw.io diagram
- [ ] Add auto-deploy workflow
- [ ] Remove hardcoded urls in `main.py`
- [ ] Add CloudWatch
- [ ] Add MinIO for storage
- [ ] Add a Postgres managed DB
- [ ] Add staging env + infra provisionning (e.g. Terraform)
- [ ] Add Healthcheck configuration