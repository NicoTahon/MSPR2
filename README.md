# 🚀 Infrastructure Kubernetes sur AWS avec Bastion Packerisé, EKS, et Odoo via Ansible & Helm

## 📋 Objectif du projet

Ce projet a pour but de :

1. Créer une image **bastion Ubuntu 22.04** avec tous les outils DevOps nécessaires via **Packer**.
2. Déployer une infrastructure complète sur **AWS** via **Terraform** : VPC, subnet, bastion EC2, cluster EKS, clés SSH, security groups.
3. Déployer l’ERP **Odoo** sur Kubernetes en utilisant **Ansible** et **Helm**, avec un certificat Let's Encrypt via **cert-manager**.

---

## 🏗️ Étape 1 : Création de l'image bastion avec Packer

### 📦 Outils installés dans l'image Ubuntu 22.04 :
- Outils CLI de base : `curl`, `unzip`, `git`, `software-properties-common`
- **AWS CLI v2**
- **kubectl** (v1.33.0)
- **Helm v3**
- **Ansible**
- **pip3**

### 📄 Provisioning utilisé :
```bash
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y curl unzip git software-properties-common

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

curl -LO https://dl.k8s.io/release/v1.33.0/bin/linux/amd64/kubectl
chmod +x kubectl && sudo mv kubectl /usr/local/bin/

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible
sudo apt install -y python3-pip

rm -rf awscliv2.zip aws
sudo apt-get clean
```

---

## ☁️ Étape 2 : Déploiement de l'infrastructure AWS avec Terraform

### 💡 Ressources créées :
- ✅ VPC & subnet public
- ✅ Internet Gateway & route table
- ✅ EC2 bastion (AMI packerisée)
- ✅ Clé SSH EC2
- ✅ Security groups
- ✅ Cluster EKS (via module terraform-aws-eks)
- ✅ Node group managé

### 📂 Fichiers Terraform :
- `vpc.tf` : réseau
- `subnets.tf` : sous-réseaux publics
- `ec2.tf` : instance bastion
- `keypair.tf` : clé SSH
- `eks-cluster.tf` : module EKS
- `variables.tf` / `outputs.tf` / `main.tf`

---

## 🧩 Étape 3 : Déploiement applicatif avec Ansible + Helm

### ✅ Déploiements automatisés via `playbook.yml` :
1. **Ingress Controller** : ingress-nginx via Helm
2. **cert-manager** : gestion des certificats (Let's Encrypt)
3. **ClusterIssuer** : ressource cert-manager pour ACME
4. **Odoo** : ERP déployé via chart Helm Bitnami

### 🔒 Certificat TLS :
- Obtention automatique via Let's Encrypt (ACME v2)
- Issuer configuré avec `http01` + ingress-nginx

---

## 🧪 Post-déploiement

```bash
kubectl get all -n ingress-nginx
kubectl get ingress -A
kubectl get certificate -A
```

---

## 📦 Prérequis techniques

- Terraform >= 1.3
- Packer >= 1.7
- AWS CLI configuré
- Ansible + collection `kubernetes.core`
- Accès AWS avec droits IAM suffisants
- Clé SSH générée (ex : `~/.ssh/ansible_key`)

---

## 📁 Arborescence

```text
packer/
├── bastion.pkr.hcl
terraform/
├── vpc.tf
├── ec2.tf
├── eks-cluster.tf
ansible/
├── deploy-ingress-nginx.yml
├── deploy-cert-manager.yml
├── cluster-issuer.yml
├── deploy-odoo.yml
├── playbook.yml
```

---

## ✍️ Auteurs

- Ton Nom – Projet MSPR TPRE912 – I2 EISI