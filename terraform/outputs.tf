output "ecr_repo_url" {
  value = aws_ecr_repository.app.repository_url
}

output "ecs_cluster" {
  value = aws_ecs_cluster.ecs.name
}

output "eks_cluster" {
  value = aws_eks_cluster.eks.name
}
