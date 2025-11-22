terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Ubuntu 24.04 LTS AMI
data "aws_ami" "ubuntu_24_04" {
  owners = ["099720109477"]  # Canonical

  filter {
    name   = "image-id"
    values = ["ami-02b8269d5e85954ef"]  # Ubuntu 24.04 LTS (x86_64)
  }
}

# Security Group for Minikube EC2
resource "aws_security_group" "minikube_sg" {
  name        = "${var.project_name}-minikube-sg"
  description = "Security group for Minikube EC2 instance"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Kubernetes NodePort range"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-minikube-sg"
    Environment = var.environment
  }
}

# EC2 Instance for Minikube
resource "aws_instance" "minikube" {
  ami                    = data.aws_ami.ubuntu_24_04.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.minikube_sg.id]

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y python3 python3-pip
              EOF

  tags = {
    Name        = "${var.project_name}-minikube-ec2"
    Environment = var.environment
  }
}
