output "oidc_provider_arn" {
  description = "OIDC ARN to be use with IRSA stuff"
  value       = module.eks.oidc_provider_arn
}
output "cluster_name" {
  description = "Cluster name"
  value       = module.eks.cluster_name
}
