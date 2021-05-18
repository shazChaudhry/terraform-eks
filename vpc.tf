provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket  = "schaudhryltd"
    key     = "eks/terraform.tfstate"
    region  = "eu-west-2"
    encrypt = true
  }
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                             = var.cluster_name
  cidr                             = var.cidr
  azs                              = data.aws_availability_zones.available.names
  private_subnets                  = [cidrsubnet(var.cidr, 8, 0), cidrsubnet(var.cidr, 8, 1), cidrsubnet(var.cidr, 8, 2)]
  public_subnets                   = [cidrsubnet(var.cidr, 8, 3), cidrsubnet(var.cidr, 8, 4), cidrsubnet(var.cidr, 8, 5)]
  enable_nat_gateway               = true
  single_nat_gateway               = true
  enable_dns_hostnames             = true
  enable_dns_support               = true
  map_public_ip_on_launch          = true
  enable_dhcp_options              = true
  dhcp_options_domain_name         = var.DnsZoneName
  dhcp_options_domain_name_servers = ["AmazonProvidedDNS"]

  tags = merge(
    var.core_tags, { "kubernetes.io/cluster/${var.cluster_name}" = "shared" },
  )

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}
