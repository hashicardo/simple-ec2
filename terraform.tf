terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~>4.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~>2.0"
    }
  }
}


provider "aws" {
  region = var.region
  default_tags {
    tags = var.default_tags
  }
}