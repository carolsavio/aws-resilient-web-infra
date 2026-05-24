# Security Group
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  vpc_id      = var.vpc_id
  description = "Permite trafego HTTP e monitoramento"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM Role para EC2
resource "aws_iam_role" "ec2_role" {
  name = "Lab-EC2-Execution-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

# Política SSM
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Política de Acesso Seguro ao S3
resource "aws_iam_policy" "s3_write_policy" {
  name        = "Lab-S3-Write-Policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:PutObject", "s3:ListBucket"]
      Resource = [var.bucket_arn, "${var.bucket_arn}/*"]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "s3_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_write_policy.arn
}

# Instancia
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "Lab-EC2-Instance-Profile"
  role = aws_iam_role.ec2_role.name
}