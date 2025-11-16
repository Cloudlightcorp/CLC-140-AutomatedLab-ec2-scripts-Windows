#######################################
# Terraform Backend Configuration (S3)
#######################################

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

#######################################
# Provider
#######################################
provider "aws" {
  region = "us-west-2"
}

#######################################
# EC2 Windows Instances (2)
#######################################
resource "aws_instance" "windows_ec2" {
  count         = 2
  ami           = "ami-0c70d556495b25a90"
  instance_type = "t3.micro"
  key_name      = "Lab_env_Windows"

  user_data = file("${path.module}/scripts/install_windows_tools.ps1")

  tags = {
    Name      = "lab-env-ec2-windows-${count.index + 1}"
    Project   = "terraform-windows-automation"
    ManagedBy = "Terraform"
    OS        = "Windows"
  }
}
