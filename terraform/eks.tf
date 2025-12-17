resource "aws_eks_cluster" "eks" {
  name     = "eks-demo-cluster"
  role_arn = "arn:aws:iam::123456789012:role/eks-role"
  vpc_config {
    subnet_ids = []
  }
}
