
# main.tf
# This file defines the main Terraform configuration for deploying an EKS cluster
terraform {

#Defines the required providers and their versions
  required_providers {
    # Used to create AWS components like VPC, EC2, EKS, etc.
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.47.0"
    }

    # Used to create a random string to append to resource names
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.1"
    }

    # Used to create TLS certificates and keys
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }

    # Used to ??? A CHANGER
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.4"
    }
  }

  required_version = "~> 1.3"

}

# Define the AWS region to use for all resources
provider "aws" {
  region = var.region
}

# Filter out local zones, which are not currently supported 
# with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}