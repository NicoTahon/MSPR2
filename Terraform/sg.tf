#sg.tf
# This file contains the security group configuration for the Bastion host and its rules.
resource "aws_security_group" "bastion_sg" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.MY_PUBLIC_IP] # my publicIP
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "bastion-sg"
  }
}

# This security group is used for the EKS cluster to allow communication between the bastion and the control plane.
resource "aws_security_group" "eks" {
  name        = "eks cluster sg"
  description = "Allow traffic"
  vpc_id      = module.vpc.vpc_id


  ingress {
    description = "Allow EKS cluster communication within the private VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "eks-sg"
  }
}