resource "aws_iam_role" "ec2_role" {
  name = "ictbit-n8n-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "secrets_manager_read" {
  name = "ictbit-secrets-read-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          "arn:aws:secretsmanager:eu-central-1:750246861878:secret:ictbit-n8n-db-credentials-pdWqFf",
          "arn:aws:secretsmanager:eu-central-1:750246861878:secret:ictbit-n8n-encryption-key-mDFpH6"
        ]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ictbit-n8n-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}
