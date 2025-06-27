#Instance type
variable "instance_type" {
  description = "Type of instance to create"
  type        = string
  default     = "t2.micro"
}

# Instance type for EKS worker nodes
variable "instance_type_eks" {
  description = "Type of instance to create"
  type        = string
  default     = "t2.medium"
}

# AMI to use for the Bastion host
variable "aws_ami" {
  description = "AMI to use for the EC2 instance"
  type        = string
  default     = "ami-0046be61906c89795" # Ubuntu 20.04 LTS in us-east-1
}

# Region to deploy resources
variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"

}

# Public IP address to allow SSH access to the Bastion host only from this IP
variable "MY_PUBLIC_IP" {
  description = "Your public IP address to allow SSH access"
  type        = string
  sensitive   = true
default = "88.174.55.227/32"
}

# AWS Access Key ID and Secret Access Key for authentication
variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key ID"
  type        = string
  sensitive   = true
  default = "AKIA2UC3CQHJGLRL73OX"
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true
  default = "h271aL0tFzJmW8pxR9oqVl/NL2x/N4u1h/tG4285"
}