variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "This is the region where network resources will be launched"
}

variable "DnsZoneName" {
  type        = string
  default     = "internal.service"
  description = "DnsZoneName"
}
variable "cluster_name" {
  type        = string
  default     = "eks-demo"
  description = "Cluster name"
}

variable "cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC cidr"
}

variable "core_tags" {
  type = map(string)
  default = {
    Terraform   = "true"
    Owner       = "user"
    Environment = "training"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }
}
