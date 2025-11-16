#############################################
# Terraform Backend (Reuse your same bucket)
#############################################
terraform {
  backend "s3" {
    bucket = "terraform-project1-state-pavithra"
    key    = "windows-ec2-lab/terraform.tfstate"
    region = "us-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#############################################
# Provider
#############################################
provider "aws" {
  region = "us-west-2"
}

#############################################
# IAM Role for Windows EC2 (SSM)
#############################################
resource "aws_iam_role" "windows_ec2_role" {
  name = "Windows-EC2-SSM-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.windows_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ec2_full" {
  role       = aws_iam_role.windows_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

#############################################
# Instance Profile
#############################################
resource "aws_iam_instance_profile" "windows_ec2_profile" {
  name = "windows-ec2-ssm-profile"
  role = aws_iam_role.windows_ec2_role.name
}

#############################################
# Windows EC2 (2 Instances)
#############################################
resource "aws_instance" "windows_lab" {
  count = 2

  ami           = "ami-0c70d556495b25a90"   # Your Windows AMI
  instance_type = "t3.micro"
  key_name      = "Lab_env_Windows"

  iam_instance_profile = aws_iam_instance_profile.windows_ec2_profile.name

  # NOTE: No user_data — SSM will handle installs

  tags = {
    Name    = "lab-env-ec2-windows-${count.index + 1}"
    Project = "terraform-windows-automation"
    OS      = "Windows"
  }
}

#############################################
# Output Instance IDs for SSM
#############################################
output "windows_instance_ids" {
  value = aws_instance.windows_lab[*].id
}
