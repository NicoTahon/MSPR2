locals {
  cluster_name = "cluster-eks-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

# This module creates an EKS cluster with two managed node groups.
# The nodes groups use the instance type specified in the variable `instance_type_eks`,
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = local.cluster_name
  cluster_version = "1.29"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_private_access          = true
  cluster_endpoint_public_access_cidrs     = ["0.0.0.0/0"]
  # This links the SG created by the module to the EKS cluster
  cluster_additional_security_group_ids = [
    aws_security_group.eks.id
  ]



  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  # This creates the worker nodes in the EKS cluster.
  # The nodes groups use the instance type specified in the variable `instance_type_eks`,
  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = [var.instance_type_eks]

      min_size     = 1
      max_size     = 3
      desired_size = 2
      # IAM role for the EBS CSI driver : allow node to manage EBS volumes
      iam_role_additional_policies = {
        ebs_csi = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }

    two = {
      name = "node-group-2"

      instance_types = [var.instance_type]

      min_size     = 1
      max_size     = 2
      desired_size = 1
      # IAM role for the EBS CSI driver : allow node to manage EBS volumes
      iam_role_additional_policies = {
        ebs_csi = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      }
    }
  }

}
