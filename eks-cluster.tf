# Kubernetes provider
# https://learn.hashicorp.com/terraform/kubernetes/provision-eks-cluster#optional-configure-terraform-kubernetes-provider
# To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/terraform/kubernetes/deploy-nginx-kubernetes

# The Kubernetes provider is included in this file so the EKS module can complete successfully. Otherwise, it throws an error when creating `kubernetes_config_map.aws_auth`.
# You should **not** schedule deployments and services in this workspace. This keeps workspaces modular (one for provision EKS, another for scheduling Kubernetes resources) as per best practices.

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.19"
  subnets         = module.vpc.private_subnets
  tags            = var.core_tags
  vpc_id          = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      asg_desired_capacity          = 2
      additional_security_group_ids = [module.worker_group_mgmt_one.security_group_id]
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.medium"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [module.worker_group_mgmt_two.security_group_id]
      asg_desired_capacity          = 1
    },
  ]
}

module "worker_group_mgmt_one" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name                = "worker_group_mgmt_one"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["10.0.0.0/8"]
  tags                = var.core_tags
}

module "worker_group_mgmt_two" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name                = "worker_group_mgmt_two"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["192.168.0.0/16"]
  tags                = var.core_tags
}

module "all_worker_mgmt" {
  source = "terraform-aws-modules/security-group/aws//modules/ssh"

  name                = "all_worker_mgmt"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  tags                = var.core_tags
}
