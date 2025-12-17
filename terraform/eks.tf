# Get supported availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Pick first 2 supported AZs
locals {
  eks_azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

# Fetch default subnets ONLY from selected AZs
data "aws_subnets" "eks" {
  filter {
    name   = "availability-zone"
    values = local.eks_azs
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

resource "aws_eks_cluster" "eks" {
  name     = "eks-demo-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = data.aws_subnets.eks.ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_policy
  ]
}
