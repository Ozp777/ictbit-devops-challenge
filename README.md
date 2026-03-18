# DevOps Engineer Challenge – n8n Deployment on AWS

## 🧭 Overview
This project demonstrates the design and deployment of a **resilient, disposable, and secure internal service** on AWS.

The selected service is **n8n (Workflow Automation)**, deployed in a way that allows compute instances to be **terminated and recreated at any time with zero data loss and minimal manual intervention**.

---

## 🏗️ Architecture


User
│
▼
Route53 (DNS)
│
▼
Application Load Balancer (HTTPS)
│
▼
Auto Scaling Group (EC2 Spot Instances)
│
▼
Docker (n8n)
│
▼
RDS PostgreSQL (Persistent Storage)


---

## 🎯 Key Features

### ✅ Disposable Compute
- Runs on **EC2 Spot Instances** to reduce cost
- Instances can be terminated at any time
- **Auto Scaling Group automatically replaces instances**

---

### 🔁 Automated Recovery
- Full bootstrap via **user_data script**
- New instances automatically:
  - Install Docker
  - Pull secrets from AWS Secrets Manager
  - Start n8n container
- **No manual intervention required**

---

### 💾 Zero-Local State
All application state is stored externally:

- **RDS PostgreSQL** – workflows, users, and execution data  
- **AWS Secrets Manager** – credentials and encryption key  
- No critical data stored on EC2 local disk  

---

### 🔐 Security

#### Secrets Management
- Database credentials stored in **AWS Secrets Manager**
- `N8N_ENCRYPTION_KEY` stored securely in Secrets Manager
- No secrets stored in code or Terraform variables

#### Network Security
- Service exposed **only via Application Load Balancer**
- Direct EC2 access is restricted
- Access limited to a **specific trusted IP/CIDR range**

#### HTTPS Only
- SSL certificate managed via **AWS ACM**
- All HTTP traffic is redirected to HTTPS

---

## 🌐 DNS Integration
- Custom domain:  
  👉 `https://n8n-demo-oz.site`
- Managed via **Route53**
- Full DNS integration instructions available in:
  👉 `DNS_RUNBOOK.md`

---

## ⚙️ Infrastructure as Code
Infrastructure is defined using **Terraform**

- Remote state stored in **S3 backend**
- Versioning enabled
- Encryption enabled
- Ensures consistency and maintainability

---

## 🔄 CI/CD (GitHub Actions)

### ✔ Infrastructure CI
On every Pull Request:

- `terraform fmt -check`
- `terraform validate`

---

### 🔐 Secure Service Interaction (Self-Hosted Runner)

The service is restricted to a **trusted IP/CIDR range**, preventing access from public GitHub runners.

To maintain security while enabling CI/CD integration:

- A **self-hosted GitHub Actions runner** is used
- The runner operates from a trusted IP environment
- This allows secure interaction with the live service

---

### ⚙️ Operational Task via CI/CD

The pipeline includes a step that interacts with the deployed service:

```bash
curl -fsS https://n8n-demo-oz.site/webhook/ops-check

This demonstrates:

Real-time service interaction

API-based automation

End-to-end integration through CI/CD

🧪 Termination Test

A manual termination of the EC2 instance was performed.

Result:

A new instance was automatically created by the ASG

The service recovered fully

All data, users, and configurations remained intact

🧩 Operational Task – n8n Webhook
Overview

An external HTTP request triggers an automated workflow inside the system.

Endpoint
https://n8n-demo-oz.site/webhook/ops-check
Flow

Request is sent to the domain

Route53 resolves to ALB

ALB forwards to EC2 instance

n8n receives request via webhook

Workflow executes

JSON response is returned

Example Request
curl https://n8n-demo-oz.site/webhook/ops-check
Example Response
{
  "status": "ok",
  "message": "n8n webhook working",
  "project": "ICTBIT"
}
Purpose

External service triggering

Automated workflow execution

Full infrastructure integration

🚀 Future Improvements

Move EC2 instances to private subnets

Add NAT Gateway or VPC endpoints

Add Terraform state locking (DynamoDB)

Improve monitoring and alerting (CloudWatch / Prometheus)

🧠 Key Takeaways

This project demonstrates:

Resilient cloud architecture design

Secure secret management

Zero-state compute pattern

Infrastructure as Code best practices

CI/CD with secure service interaction

Production-grade deployment patterns

👤 Author

DevOps Engineer Candidate
