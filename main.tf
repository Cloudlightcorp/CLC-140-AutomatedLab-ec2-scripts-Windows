###########################################
# Backend
###########################################
terraform {
  backend "s3" {
    bucket = "terraform-project1-state-pavithra"
    key    = "windows-ec2-project/terraform.tfstate"
    region = "us-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

###########################################
# Provider
###########################################
provider "aws" {
  region = "us-west-2"
}

###########################################
# Windows EC2 (2 Instances)
###########################################
resource "aws_instance" "windows_ec2" {
  count         = 2
  ami           = "ami-0c70d556495b25a90"
  instance_type = "t3.large"
  key_name      = "Lab_env_Windows"

  # User data to install apps
  user_data = file("${path.module}/scripts/install_windows_tools.ps1")

  tags = {
    Name      = "lab-env-ec2-windows-${count.index + 1}"
    Project   = "terraform-windows-automation"
    ManagedBy = "Terraform"
  }
}

###########################################
# Outputs
###########################################
output "windows_instance_ids" {
  value = aws_instance.windows_ec2[*].id
}
