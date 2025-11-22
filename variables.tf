variable "project_name" {
  description = "Project/name prefix for resources"
  type        = string
  default     = "minikube-lab"
}

variable "environment" {
  description = "Environment tag"
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region to deploy EC2"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type for Minikube"
  type        = string
  default     = "t3.small"
  # For heavier workloads you can use t3.large / t3.xlarge
}

variable "key_name" {
  description = "Existing AWS key pair name for SSH"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EC2 will be created"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type        = string
}

variable "root_volume_size" {
  description = "Root disk size in GB for the EC2 instance"
  type        = number
  default     = 50
}

variable "allowed_ssh_cidrs" {
  description = "List of CIDR blocks allowed to SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Change to your IP for better security
}
