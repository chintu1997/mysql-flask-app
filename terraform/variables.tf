variable "region" {
  description = "The AWS region to deploy into"
  default     = "eu-west-2"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  default     = "test-eks-cluster"
}

variable "existing_vpc_id" {
  description = "The ID of the existing VPC"
  default     = "vpc-09dd2553c47b9e8c6"
}

variable "private_subnets" {
  description = "List of private subnet IDs in the existing VPC"
  default     = ["subnet-06546421cedf3ee13", "subnet-0e7e91c9339b9449b", "subnet-0ddd5620b50afb0f8"]
}
