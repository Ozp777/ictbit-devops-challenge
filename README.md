# 🚀 DevOps Engineer Challenge – n8n Deployment on AWS

## 🧭 Overview

This project demonstrates the design and deployment of a resilient, disposable, and secure internal service using AWS.

The selected service is **n8n (Workflow Automation)**, deployed in a way that allows compute instances to be destroyed and recreated at any time with **zero data loss and minimal manual intervention**.

---

## 🏗️ Architecture

The system is built using a highly available and fault-tolerant architecture:

```
Internet
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
```

---

## 🎯 Key Features

### ✅ Disposable Compute

* Uses **EC2 Spot Instances** to reduce cost
* Instances can be terminated at any time
* Auto Scaling Group automatically replaces instances

---

### 🔁 Automated Recovery

* Full bootstrap via **user_data script**
* New instances automatically:

  * Install Docker
  * Pull secrets from AWS Secrets Manager
  * Start n8n container
* No manual intervention required

---

### 💾 Zero Data Loss

* All state is stored externally:

  * **RDS PostgreSQL** – application data
  * **Secrets Manager** – credentials and encryption key
* No critical data stored on EC2 local disk

---

### 🔐 Security

#### Secrets Management

* Database credentials stored in **AWS Secrets Manager**
* `N8N_ENCRYPTION_KEY` stored securely in Secrets Manager
* No secrets stored in source code or `tfvars`

#### Network Security

* Service exposed via **Application Load Balancer only**
* Direct access to EC2 is restricted
* Access limited to specific IP/CIDR range

#### HTTPS Only

* SSL certificate managed via **AWS ACM**
* All HTTP traffic redirected to HTTPS

---

### 🌐 DNS Integration

* Custom domain:
  `https://n8n-demo-oz.site`
* Managed via **Route53**
* Full DNS runbook provided

---

## ⚙️ Infrastructure as Code

* Infrastructure is defined using **Terraform**
* Remote state stored in **S3 backend**

  * Versioning enabled
  * Encryption enabled
* Ensures maintainability and consistency

---

## 🔄 CI/CD (GitHub Actions)

A CI pipeline is implemented using GitHub Actions:

### ✔ Infrastructure CI

On every Pull Request:

* `terraform fmt -check`
* `terraform validate`

### ⚠️ Note on Service Health Checks

The public endpoint is restricted to a specific IP/CIDR range.

Therefore, GitHub-hosted runners cannot access the service directly.

* Service health is validated via:

  * ALB target group health checks
  * Manual verification from allowed IP

---

## 🧪 Termination Test

The system was tested by manually terminating the EC2 instance.

Result:

* A new instance was automatically created
* The service resumed successfully
* All data, users, and configurations remained intact

---

## 📄 DNS Runbook

A detailed DNS integration guide is available in:

```
DNS_RUNBOOK.md
```

---

## 🚀 Future Improvements

* Move EC2 instances to **private subnets**
* Add **NAT Gateway or VPC Endpoints**
* Implement **self-hosted GitHub runner**
* Add **Terraform state locking (DynamoDB)**
* Enhance monitoring and alerting

---

## 🧠 Key Takeaways

This project demonstrates:

* Resilient cloud architecture design
* Secure secret management
* Automated infrastructure provisioning
* Production-grade deployment patterns

---

## 👤 Author

DevOps Engineer Candidate

