# Create a EC2 instance Bastion
resource "aws_instance" "bastion" {
  ami                         = var.aws_ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = aws_key_pair.deployer.key_name
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  # wait for the kubeconfig to be generated before creating the instance
  # this is to ensure that the kubeconfig is available when the instance is created
  depends_on = [null_resource.generate_kubeconfig]

  tags = {
    Name = "bastion"
  }

  # Copy the private key to the instance
  provisioner "file" {
    source      = local_file.private_key.filename
    destination = "/home/ubuntu/deployer-key.pem"
  }

  # Copy the kubeconfig file to the instance
  provisioner "file" {
    source      = "${path.module}/kubeconfig"
    destination = "/home/ubuntu/kubeconfig"
  }

  # Set permissions for the private key
  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ubuntu/deployer-key.pem"
    ]
  }

  # Move the kubeconfig file to the .kube directory and set permissions
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/ubuntu/.kube",
      "mv /home/ubuntu/kubeconfig /home/ubuntu/.kube/config",
      "chown ubuntu:ubuntu /home/ubuntu/.kube/config",
      "chmod 600 /home/ubuntu/.kube/config",
    ]
  }

  # configure aws cli
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "aws configure set region ${var.region}",
      "aws configure set output json",
      "aws configure set aws_access_key_id ${var.AWS_ACCESS_KEY_ID}",
      "aws configure set aws_secret_access_key ${var.AWS_SECRET_ACCESS_KEY}",
      "aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name} --kubeconfig /home/ubuntu/.kube/config"
    ]
  }

    # Copy the kubeconfig file to the instance
  provisioner "file" {
    source      = "ansible/install-ebs-csi.yml"
    destination = "/home/ubuntu/kubeconfig"
  }

  # Sending the playbook to the instance
  provisioner "file" {
    source      = "ansible/playbooks.tar" # Chemin local de l'archive
    destination = "playbooks.tar" # Chemin sur l'EC2
  }

  # Décompresser l'archive playbooks.tar
  provisioner "remote-exec" {
    inline = [
      "tar -xvf playbooks.tar", # Décompresser l'archive
    ]
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file(local_file.private_key.filename)
    timeout     = "4m"
  }


}