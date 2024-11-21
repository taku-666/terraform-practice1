# Terraform バージョンとプロバイダーの設定
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Workspaceに応じた環境変数の設定
variable "region" {
  description = "AWSリージョン"
  type        = string
  default     = "us-west-2"
}

# EC2インスタンス作成時に使用する既存のセキュリティグループとサブネットのID
variable "security_group_id" {
  description = "既存のセキュリティグループID"
  type        = string
}

variable "subnet_id" {
  description = "既存のサブネットID"
  type        = string
}

variable "ami_id" {
  description = "EC2インスタンスに使用するAMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2インスタンスのタイプ"
  type        = string
  default     = "t3.micro"
}

# EC2インスタンスの作成
resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "${terraform.workspace}-ec2-instance"
  }
}

# 出力値
output "instance_id" {
  description = "EC2インスタンスのID"
  value       = aws_instance.example.id
}
output "public_ip" {
  description = "EC2インスタンスのパブリックIP"
  value       = aws_instance.example.public_ip
}
