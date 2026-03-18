DNS_RUNBOOK.md

This document describes how to configure DNS in order to expose the internal service (n8n) via a secure custom domain using AWS.

The service is deployed behind an Application Load Balancer (ALB) and secured with HTTPS using AWS Certificate Manager (ACM).

🌐 Domain Details

Domain: n8n-demo-oz.site

Service URL: https://n8n-demo-oz.site

Load Balancer DNS:

ictbit-n8n-alb-707229798.eu-central-1.elb.amazonaws.com
🔧 DNS Configuration Steps
Step 1 – Delegate DNS to Route53 (if needed)

If the domain is managed outside AWS:

Update the domain's nameservers to the following Route53 nameservers:

ns-1727.awsdns-23.co.uk.
ns-1015.awsdns-62.net.
ns-1157.awsdns-16.org.
ns-110.awsdns-13.com.

Step 2 – Create DNS Record

Create an A Record (Alias) pointing to the ALB:

Record Name: n8n-demo-oz.site

Record Type: A

Alias: Yes

Alias Target:

ictbit-n8n-alb-707229798.eu-central-1.elb.amazonaws.com
🔐 HTTPS Configuration

SSL certificate is managed via AWS ACM

Domain validated using DNS (CNAME record)

HTTPS is enforced via ALB listener (port 443)

All HTTP traffic (port 80) is redirected to HTTPS

🔒 Access Restrictions

Access to the service is restricted via Security Groups:

Only specific IP/CIDR ranges are allowed (e.g., office/VPN)

Public access is blocked

✅ Verification Steps

Open browser:

https://n8n-demo-oz.site

Verify:

🔒 HTTPS is active

Redirect from HTTP works

Login page loads successfully

⚠️ Notes

DNS propagation may take a few minutes

Ensure correct nameservers are configured

ACM certificate must be in ISSUED state
