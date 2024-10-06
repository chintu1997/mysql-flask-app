variable "region" {
  description = "The AWS region to deploy into"
  default     = "eu-west-2"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  default     = "test-eks-cluster"
}
