output "eks_cluster_outputs" {
  value = {
    region                    = var.region
    cluster_name              = var.cluster_name
    cluster_id                = module.eks.cluster_id
    cluster_endpoint          = module.eks.cluster_endpoint
    cluster_security_group_id = module.eks.cluster_security_group_id
    kubectl_config            = module.eks.kubeconfig
    config_map_aws_auth       = module.eks.config_map_aws_auth
  }
}
