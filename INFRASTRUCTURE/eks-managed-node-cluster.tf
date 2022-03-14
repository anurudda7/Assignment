locals {
  name            = "managed_nodes-${random_string.suffix.result}"
  cluster_name = "demo-eks-cluster"
  cluster_version = "1.21"
}

################################################################################
# EKS Module
################################################################################

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"

  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  cluster_create_endpoint_private_access_sg_rule = true
  cluster_endpoint_private_access_cidrs = ["10.10.101.0/24"]

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50
  }

  node_groups = {
    node-group-1 = {
      desired_capacity = 1
      max_capacity     = 3
      min_capacity     = 1

      instance_types = ["t2.medium","t3.large","t3.xlarge"]
      capacity_type  = "ON_DEMAND"
      k8s_labels = {
        Resource    = "managed_node_groups"
        Owner       = "sampath"
        Environment = "demo"
      }
      additional_tags = {
        ExtraTag = "demo"
      }
      /* taints = [
        {
          key    = "dedicated"
          value  = "gpuGroup"
          effect = "NO_SCHEDULE"
        }
      ] */
      update_config = {
        max_unavailable_percentage = 50 # or set `max_unavailable`
      }
    }

  }
  tags = {
        Resource    = local.name
        Owner       = "sampath"
        Environment = "demo"
  }
}

################################################################################
# Kubernetes provider configuration
################################################################################

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

################################################################################
# Supporting Resources
################################################################################

data "aws_availability_zones" "available" {
}

resource "random_string" "suffix" {
  length  = 4
  special = false
}

