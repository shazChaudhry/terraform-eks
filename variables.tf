variable "region" {
  description = "AWS London region to launch servers"
  default     = "eu-west-2"
}

variable "credentials" {
  default = "~/.aws/credentials"
}

variable "cluster-name" {
  default = "terraform-eks-demo"
  type    = "string"
}
