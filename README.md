# 🚀 Azure Three-Tier WordPress Infrastructure

## 🎯 Overview

This project implements a robust, scalable Three-Tier WordPress deployment on Microsoft Azure using Infrastructure as Code (IaC) with Terraform. The architecture follows cloud-native best practices with high availability and regional deployment capabilities.

## 🏗️ Architecture

### **Network Layer** 🌐
- Custom Virtual Network (VNET)
- Three-subnet architecture:
  - Subnet 1: Reserved for future use
  - Subnet 2: Dedicated Gateway subnet
  - Subnet 3: Application tier (Scale Set + NSG)

### **Application Layer** 💻
- **Linux Virtual Machine Scale Set**
  - Based on CentOS 7.9
  - Auto-scaling capabilities
  - Custom WordPress deployment script
  - Load balanced configuration
- **Traffic Manager**
  - Priority-based routing
  - Health monitoring
  - Global DNS management

### **Database Layer** 📊
- **Azure MySQL Server**
  - MySQL 5.7
  - Automated backups
  - SSL configuration
  - Firewall rules for secure access

## 🌍 Multi-Region Deployment

Supports deployment across multiple Azure regions:
- 🇺🇸 US East
- 🇪🇺 West Europe
- 🇬🇧 UK South
- 🇮🇳 Central India
- 🇨🇦 Canada East
- 🇳🇴 Norway East
- 🇩🇪 Germany West Central
- 🇯🇵 Asia Pacific

## 🛠️ Technical Features

- **Load Balancing:**
  - Azure Load Balancer with public IP
  - HTTP (80) and SSH (22) health probes
  - Backend pool configuration

- **Security:**
  - Network Security Groups (NSG)
  - Controlled public access
  - Database firewall rules

- **WordPress Configuration:**
  - Automated installation script
  - PHP 7.3 environment
  - Apache web server
  - Custom template integration

## 🚀 Quick Start

1. Configure Azure credentials
2. Update variables in `terraform.tfvars`
3. Choose your region in the corresponding `.tfvars` file
4. Deploy using Make commands:
```bash
# Initialize
make init

# Deploy to specific region
make us-east-apply
```

## ⚠️ Prerequisites

- Terraform >= 0.12
- Azure CLI
- AWS CLI (for Route53 integration)
- Make utility

## 📝 Notes

- Configured for production-grade deployment
- Includes AWS Route53 integration for DNS management
- Automated WordPress installation and configuration
- Scalable architecture supporting multi-region deployment

## 🔒 Security Notice

Default credentials are configured for demonstration. **MUST** be changed for production use:
- MySQL admin credentials
- VM admin credentials
- SSL/TLS configurations
