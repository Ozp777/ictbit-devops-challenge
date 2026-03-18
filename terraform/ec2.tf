resource "aws_launch_template" "n8n" {
  name_prefix   = "${var.project_name}-lt"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name      = "ictbit-key"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2.id]
  }

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
yum install -y docker jq awscli

systemctl enable docker
systemctl start docker

SECRET=$(aws secretsmanager get-secret-value \
  --region eu-central-1 \
  --secret-id ictbit-n8n-db-credentials \
  --query SecretString \
  --output text)

DB_USERNAME=$(echo "$SECRET" | jq -r '.username')
DB_PASSWORD=$(echo "$SECRET" | jq -r '.password')

N8N_SECRET=$(aws secretsmanager get-secret-value \
  --region eu-central-1 \
  --secret-id ictbit-n8n-encryption-key \
  --query SecretString \
  --output text)

N8N_ENCRYPTION_KEY=$(echo "$N8N_SECRET" | jq -r '.key')

docker rm -f n8n || true

docker run -d --name n8n -p 5678:5678 \
  -e DB_TYPE=postgresdb \
  -e DB_POSTGRESDB_HOST=${aws_db_instance.n8n.address} \
  -e N8N_ENCRYPTION_KEY=$N8N_ENCRYPTION_KEY \
  -e DB_POSTGRESDB_PORT=5432 \
  -e DB_POSTGRESDB_DATABASE=${var.db_name} \
  -e DB_POSTGRESDB_USER=$DB_USERNAME \
  -e DB_POSTGRESDB_PASSWORD=$DB_PASSWORD \
  -e DB_POSTGRESDB_SSL_ENABLED=true \
  -e DB_POSTGRESDB_SSL_REJECT_UNAUTHORIZED=false \
  -e N8N_HOST=n8n-demo-oz.site \
  -e N8N_PROTOCOL=https \
  -e N8N_PORT=5678 \
  -e N8N_EDITOR_BASE_URL=https://n8n-demo-oz.site \
  -e WEBHOOK_URL=https://n8n-demo-oz.site/ \
  n8nio/n8n
EOF
  )

  instance_market_options {
    market_type = "spot"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-n8n"
    }
  }
}

resource "aws_autoscaling_group" "n8n" {
  name = "${var.project_name}-asg"

  desired_capacity = 1
  min_size         = 1
  max_size         = 1

  vpc_zone_identifier = aws_subnet.public[*].id

  target_group_arns = [
    aws_lb_target_group.n8n.arn
  ]

  launch_template {
    id      = aws_launch_template.n8n.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-instance"
    propagate_at_launch = true
  }
}
