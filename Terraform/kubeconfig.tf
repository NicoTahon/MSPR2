# This Terraform configuration generates a kubeconfig file for an EKS cluster.
# It is used later to configure kubectl in the bastion to interact with the EKS cluster.
resource "null_resource" "generate_kubeconfig" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name} --kubeconfig=./kubeconfig"
  }

  # This resource depends on the EKS module to ensure the cluster is created before generating the kubeconfig
  triggers = {
    cluster_name = module.eks.cluster_name
    region       = var.region
  }
}