#Instance type
variable "instance_type" {
  description = "Type of instance to create"
  type        = string
  default     = "t2.micro"
}

variable "instance_type_eks" {
  description = "Type of instance to create"
  type        = string
  default     = "t2.medium"
}

variable "aws_ami" {
  description = "AMI to use for the EC2 instance"
  type        = string
  default     = "ami-0dbc89b325e2b1479" # Ubuntu 20.04 LTS in us-east-1
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"

}

variable "MY_PUBLIC_IP" {
  description = "Your public IP address to allow SSH access"
  type        = string
  sensitive   = true
  default     = "88.174.55.227/32"

}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key ID"
  type        = string
  sensitive   = true
  default     = "AKIA5FTZCYRNABL4S3YD"
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive   = true
  default     = "qn9e6PdrnWWbp4cQnGDJUvn7QgcKd8qOBMOYlwxk"
}