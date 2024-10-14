output "cluster_name" {
  value = aws_eks_cluster.eks.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "certificate_authority_data" {
  value = aws_eks_cluster.eks.certificate_authority[0].data
}

output "eks_worker_sg_id" {
  description = "The security group ID for EKS worker nodes"
  value       = aws_security_group.eks_worker_sg.id
}
