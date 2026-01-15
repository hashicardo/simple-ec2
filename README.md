# VM Identity Card - Terraform Module

Deploys an EC2 instance with a responsive web app that displays VM metadata (hostname, OS, instance type, and public IP) in a customizable identity card.

## Usage

```hcl
module "vm_identity" {
  source = "./simple-ec2"
  
  page_title = "My Infrastructure"
  image_url  = "https://example.com/customer-logo.png"
  prefix     = "demo"
  region     = "us-east-1"
}
```

## Variables

| Name | Description | Default |
|------|-------------|---------|
| `page_title` | Title displayed above the VM card | `"Hello, world!"` |
| `image_url` | URL for customer logo (required) | - |
| `prefix` | Resource name prefix | `"hashicardo"` |
| `region` | AWS region | `"eu-west-2"` |

## Outputs

| Name | Description |
|------|-------------|
| `hostname` | URL to access the web app |
| `ip` | Public IP address of the EC2 instance |
| `private_key` | SSH private key (sensitive) |

## What Gets Deployed

- VPC with public subnet
- EC2 instance (Ubuntu 24.04 ARM64, t4g.small)
- Nginx web server
- Responsive VM identity card web app

