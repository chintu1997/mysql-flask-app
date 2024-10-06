provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_cluster_auth.token
}

data "aws_eks_cluster" "eks_cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "eks_cluster_auth" {
  name = module.eks.cluster_id
}

# Data source to get the IAM role of the node group
data "aws_iam_role" "node_group_role" {
  name = module.eks.node_groups["eks_nodes"].iam_role_name
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.1.0"

  cluster_name    = "test-eks-cluster"
  cluster_version = "1.24"

  vpc_id  = var.existing_vpc_id
  subnets = var.private_subnets

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t2.micro"
    }
  }
}

resource "kubernetes_config_map" "aws_auth" {
  depends_on = [module.eks]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode([
      {
        rolearn  = data.aws_iam_role.node_group_role.arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      }
    ])

    mapUsers = yamlencode([
      {
        userarn  = "arn:aws:iam::183295450711:user/terraform-user"
        username = "terraform-user"
        groups   = ["system:masters"]
      }
    ])
  }
}
