output "project_name" {
  value = var.project_name
}

output "aws_region" {
  value = var.aws_region
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "availability_zones_used" {
  value = data.aws_availability_zones.available.names
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Hosted zone ID of the Application Load Balancer"
  value       = aws_lb.main.zone_id
}

output "target_group_arn" {
  description = "ARN of the n8n target group"
  value       = aws_lb_target_group.n8n.arn
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.n8n.address
}

output "rds_port" {
  description = "RDS port"
  value       = aws_db_instance.n8n.port
}

output "rds_db_name" {
  description = "RDS database name"
  value       = aws_db_instance.n8n.db_name
}
