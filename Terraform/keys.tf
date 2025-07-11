# # keys.tf
# Generate SSH key
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create key pair in AWS to connect to the EC2 instance
# This key pair will be used to connect to the Bastion host and EKS worker nodes
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key3"
  public_key = tls_private_key.key.public_key_openssh
}

# Store private key locally
resource "local_file" "private_key" {
  content         = tls_private_key.key.private_key_pem
  filename        = "${path.module}/deployer-key.pem"
  file_permission = "0600"
}
