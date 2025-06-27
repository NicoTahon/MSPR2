// ============================================================
// Image Bastion DevOps – Packer HCL2
// 
// Objectif : Créer une image AMI AWS Ubuntu 22.04 servant
// de bastion d’administration pour un projet Kubernetes EKS.
// Cette image contient tous les outils DevOps nécessaires.
//
// Outils installés :
// - curl : téléchargement de fichiers via HTTP/HTTPS
// - unzip : extraction d’archives zip (ex : awscli, terraform…)
// - git : versionnement, clonage de dépôts
// - software-properties-common : gestion de dépôts APT externes
// - aws-cli : interaction avec AWS (création de ressources, login EKS, etc.)
// - kubectl : gestion de clusters Kubernetes
// - helm : gestion de charts Kubernetes (ex : Odoo)
// - terraform : Infrastructure as Code pour AWS (VPC, EKS, etc.)
// - ansible : configuration et déploiement (ex : applicatif Odoo)
//
// Utilisation :
// - packer init .
// - packer validate .
// - packer build bastion.pkr.hcl
//
// À ne pas oublier :
// - Ne pas intégrer de secrets dans le fichier ou l'image.
// - Lancer cette image dans un VPC sécurisé avec accès restreint (bastion).
//
// Auteur : [Ton Nom]
// Projet : MSPR TPRE912 – Infrastructure virtualisée avec EKS
// Date : [Date de création]
// ============================================================

packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}


source "amazon-ebs" "bastion" {
  ami_name      = "bastion-devops-${local.timestamp}"
  instance_type = var.instance_type
  region        = var.aws_region
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      virtualization-type = "hvm"
      root-device-type    = "ebs"
    }
    owners      = ["099720109477"]
    most_recent = true
  }
  ssh_username = "ubuntu"
}

build {
  name    = "bastion-AMI-build"
  sources = ["source.amazon-ebs.bastion"]

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      # Outils CLI essentiels
      "sudo apt-get install -y curl unzip git software-properties-common",
      # AWS CLI v2
      "curl 'https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip' -o 'awscliv2.zip'",
      "unzip awscliv2.zip",
      "sudo ./aws/install",
      # Kubectl
      "curl -LO https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl",
      "chmod +x kubectl && sudo mv kubectl /usr/local/bin/",
      # Helm
      "curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash",
      # Ansible
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt-get install -y ansible",
      "sudo apt install -y python3-pip"
      # Nettoyage
      "rm -rf awscliv2.zip aws",
      "sudo apt-get clean"
    ]
  }
}
