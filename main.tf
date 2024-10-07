provider "aws" {
  region = "eu-west-2"
}

# Create a VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-2a", "eu-west-2b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  tags = {
    Name = "eks-vpc"
  }
}

# Create an EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.24.3"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.24"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  # Managed node groups
  eks_managed_node_groups = {
    eks_node_group = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_type = "t3.medium"

      key_name = "my-eks-key"  # Replace with your SSH key pair name if needed
    }
  }

  tags = {
    Environment = "dev"
    Name        = "my-eks-cluster"
  }

  # Enable the EKS cluster endpoint access
  cluster_endpoint_public_access = true
}

# Output the EKS cluster name and cluster endpoint
output "eks_cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

# Output Node Group details
output "node_group_name" {
  description = "The name of the EKS Node Group"
  value       = module.eks.eks_managed_node_groups["eks_node_group"].id
}
