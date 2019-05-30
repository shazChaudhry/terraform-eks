output "kubeconfig" {
  value = "${local.kubeconfig}"
}

output "config_map_aws_auth" {
  value = "${local.config_map_aws_auth}"
}

output "aws_eks_cluster_endpoint" {
  value = "${aws_eks_cluster.demo.endpoint}"
}
