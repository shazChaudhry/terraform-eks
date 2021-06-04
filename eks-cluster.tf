# Render a part using a `template_file:
# https://www.terraform.io/docs/providers/template/d/cloudinit_config.html
data "template_file" "cloud-config-packages" {
  template = file("${path.module}/templates/cloud-config-packages.tpl")
}

# Render a multi-part cloud-init config making use of the part above, and other source files
data "template_cloudinit_config" "init_config" {
  part {
    content = data.template_file.cloud-config-packages.rendered
  }
}

module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  cluster_name                    = var.cluster_name
  cluster_version                 = "1.20"
  subnets                         = module.vpc.private_subnets
  tags                            = var.core_tags
  vpc_id                          = module.vpc.vpc_id
  cluster_endpoint_private_access = true

  workers_group_defaults = {
    root_volume_type    = "gp2"
    additional_userdata = data.template_cloudinit_config.init_config.rendered
  }

  worker_groups = [
    {
      name                 = "worker-group-1"
      instance_type        = "t2.small"
      asg_desired_capacity = 2
    },
    {
      name                 = "worker-group-2"
      instance_type        = "t2.medium"
      asg_desired_capacity = 1
    },
  ]
}

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

// metrics-server installation
// https://registry.terraform.io/modules/iplabs/metrics-server/kubernetes/latest
module "metrics-server" {
  source = "iplabs/metrics-server/kubernetes"
}
