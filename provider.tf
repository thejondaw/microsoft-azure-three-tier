# Specify Terraform Provider and Version
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.81.0"
    }
  }
}

provider "azurerm" {
  # Skip automatic provider registration
  skip_provider_registration = true
  features {}
}

# ---------------------------------------------------------------------------

# Configure the AWS account
provider "aws" {
  region     = "us-east-1"
  access_key = ""
  secret_key = ""
}

# AWS Route 53
resource "aws_route53_record" "wordpressdb" {
  zone_id = ""
  name    = "wordpress..net"
  type    = "A"
  ttl     = 300
  records = [azurerm_public_ip.example.ip_address]
}
