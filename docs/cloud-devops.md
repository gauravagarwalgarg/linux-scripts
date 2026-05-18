# ☁️ Cloud & DevOps Tooling Guide

> Run production-grade infrastructure locally. Test before you deploy. Break things safely.

---

## 🧰 What Gets Installed

| Tool | Purpose | Local Equivalent |
|------|---------|-----------------|
| Docker | Container runtime | — (it IS the local equivalent) |
| kubectl | Kubernetes CLI | Talks to Minikube/kind locally |
| Helm | K8s package manager | Deploy charts to local cluster |
| k9s | Kubernetes TUI | Monitor local/remote clusters |
| Terraform | Infrastructure as Code | Plan/apply against LocalStack |
| AWS CLI | Amazon Web Services | Configure for LocalStack |
| GCP CLI | Google Cloud Platform | `gcloud` emulators |
| Minikube | Local Kubernetes cluster | Single-node K8s on your laptop |
| LocalStack | Local AWS emulation | S3, Lambda, DynamoDB, SQS locally |
| Ansible | Configuration management | Test playbooks against local VMs |

---

## 🐳 Docker — The Foundation

Everything in cloud-native starts with containers.

### Essential Commands

```bash
# Build an image
docker build -t myapp:latest .

# Run a container
docker run -d -p 8080:80 --name web myapp:latest

# Interactive shell inside container
docker exec -it web /bin/bash

# View logs
docker logs -f web

# Clean up everything
docker system prune -af --volumes
```

### Docker Compose — Multi-Container Apps

```yaml
# docker-compose.yml
services:
  app:
    build: .
    ports:
      - "8080:8080"
    depends_on:
      - db
      - redis
  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: dev
    volumes:
      - pgdata:/var/lib/postgresql/data
  redis:
    image: redis:7-alpine

volumes:
  pgdata:
```

```bash
docker compose up -d      # Start all services
docker compose logs -f    # Follow all logs
docker compose down -v    # Stop and remove volumes
```

### Anecdote
> *"Before Docker, 'works on my machine' was a meme. Now it's a guarantee — if it runs in the container, it runs everywhere. The first time I shipped a multi-service app with `docker compose up` and it just worked in CI, I understood why containers won."*

---

## ☸️ Kubernetes — Locally

### Minikube (Single-Node Cluster)

```bash
# Start a local cluster
minikube start --driver=docker --memory=4096 --cpus=2

# Dashboard
minikube dashboard

# Deploy an app
kubectl create deployment hello --image=nginx
kubectl expose deployment hello --port=80 --type=NodePort
minikube service hello --url

# Stop (preserves state)
minikube stop

# Delete (clean slate)
minikube delete
```

### kind (Kubernetes in Docker) — Lighter Alternative

```bash
# Install
go install sigs.k8s.io/kind@latest

# Create cluster
kind create cluster --name dev

# Load local images (no registry needed)
kind load docker-image myapp:latest --name dev

# Delete
kind delete cluster --name dev
```

### k9s — The Kubernetes TUI

```bash
k9s
# Navigate:
# :pods          → list pods
# :deploy        → list deployments
# :svc           → list services
# /pattern       → filter
# d              → describe
# l              → logs
# s              → shell into pod
# ctrl+d         → delete
# :q             → quit
```

### Anecdote
> *"k9s replaced my need for Lens, kubectl get, and half my terminal tabs. It's like htop for Kubernetes. Once you try it, you can't go back to raw kubectl."*

---

## 🏗️ Terraform — Infrastructure as Code

### Local Development with LocalStack

```bash
# Start LocalStack
localstack start -d

# Configure AWS CLI to point to LocalStack
aws configure set aws_access_key_id test
aws configure set aws_secret_access_key test
aws configure set region us-east-1

# Use --endpoint-url for LocalStack
aws --endpoint-url=http://localhost:4566 s3 mb s3://my-bucket
aws --endpoint-url=http://localhost:4566 s3 ls
```

### Terraform Against LocalStack

```hcl
# main.tf
provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3       = "http://localhost:4566"
    dynamodb = "http://localhost:4566"
    lambda   = "http://localhost:4566"
    sqs      = "http://localhost:4566"
    iam      = "http://localhost:4566"
  }
}

resource "aws_s3_bucket" "data" {
  bucket = "my-data-bucket"
}

resource "aws_dynamodb_table" "users" {
  name         = "users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }
}
```

```bash
terraform init
terraform plan
terraform apply -auto-approve
# All resources created locally — no AWS bill
```

### Anecdote
> *"I once ran `terraform destroy` on the wrong workspace and deleted a production DynamoDB table. Since then, I test every Terraform change against LocalStack first. The 5 minutes of local testing saved me from a 3 AM incident."*

---

## 🔧 GCP Local Development

### Emulators

```bash
# Pub/Sub emulator
gcloud beta emulators pubsub start --project=test-project

# Datastore emulator
gcloud beta emulators datastore start --project=test-project

# Firestore emulator
gcloud beta emulators firestore start --project=test-project

# Set environment to use emulator
$(gcloud beta emulators pubsub env-init)
```

### Local Functions

```bash
# Install Functions Framework
pip install functions-framework

# Run locally
functions-framework --target=my_function --debug
```

---

## 📦 Helm — Kubernetes Package Manager

```bash
# Add a chart repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Search for charts
helm search repo postgresql

# Install a chart
helm install my-db bitnami/postgresql --set auth.postgresPassword=dev

# List releases
helm list

# Upgrade
helm upgrade my-db bitnami/postgresql --set auth.postgresPassword=newpass

# Uninstall
helm uninstall my-db

# Create your own chart
helm create my-app
```

---

## 🔄 CI/CD Locally

### GitHub Actions (act)

Run GitHub Actions workflows locally:

```bash
# Install
curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Run default workflow
act

# Run specific job
act -j build

# Run with specific event
act pull_request
```

### GitLab CI (gitlab-runner)

```bash
# Install
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt install gitlab-runner

# Run a job locally
gitlab-runner exec docker build
```

---

## 🛡️ Security Scanning

```bash
# Scan Docker images for vulnerabilities
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image myapp:latest

# Scan Terraform for misconfigurations
docker run --rm -v $(pwd):/src aquasec/tfsec /src

# Scan Kubernetes manifests
docker run --rm -v $(pwd):/src kubesec/kubesec scan /src/deployment.yaml
```

---

## 📋 Typical Cloud Dev Workflow

```
1. Write infrastructure (Terraform)
2. Test locally (LocalStack / emulators)
3. Write application (Docker container)
4. Test locally (docker compose up)
5. Deploy to local K8s (Minikube + Helm)
6. Validate (k9s, curl, logs)
7. Push to CI (GitHub Actions / GitLab CI)
8. Deploy to staging (Terraform apply)
9. Promote to production (same Terraform, different vars)
```

### The Golden Rule

> **If you can't run it locally, you can't debug it efficiently.** Every cloud service should have a local equivalent for development.

| Cloud Service | Local Equivalent |
|---------------|-----------------|
| AWS S3 | LocalStack / MinIO |
| AWS Lambda | LocalStack / SAM CLI |
| AWS DynamoDB | LocalStack / DynamoDB Local |
| AWS SQS/SNS | LocalStack |
| GCP Pub/Sub | gcloud emulator |
| GCP Firestore | gcloud emulator |
| Kubernetes | Minikube / kind |
| CI/CD | act / gitlab-runner exec |

---

*"Cloud is just someone else's computer. Local development is YOUR computer. Master both."*
