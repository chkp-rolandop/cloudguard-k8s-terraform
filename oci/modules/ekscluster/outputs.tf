output "kubernetes_cluster_id" {
  value = data.aws_eks_cluster.cluster.id
}

output "kubernetes_cluster_name" {
  value = module.eks-cluster.cluster_name
}

output "kubernetes_cluster_endpoint" {
  value = data.aws_eks_cluster.cluster.endpoint
}

output "access_token" {
  value = data.aws_eks_cluster_auth.cluster.token
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
}
