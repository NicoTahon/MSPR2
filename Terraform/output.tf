output "ssh_command_ansible" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i deployer-key.pem ubuntu@${aws_instance.bastion.public_ip}"
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "region" {
  description = "AWS region"
  value       = var.region
}


output "kubeconfig" {
  description = "Kubeconfig file content for the EKS cluster"
  value       = "Command for obtaining kubectl config : aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name}"

}