data "aws_eks_cluster" "existing_cluster" {
  name = "test-eks-cluster"

  count = length(try(data.aws_eks_cluster.existing_cluster[*].id, []))
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.1.0"

  cluster_name    = "test-eks-cluster"
  cluster_version = "1.24"

  subnets         = var.private_subnets
  vpc_id          = var.existing_vpc_id

  create_eks      = length(data.aws_eks_cluster.existing_cluster) == 0

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_type = "t2.micro"
    }
  }
}

