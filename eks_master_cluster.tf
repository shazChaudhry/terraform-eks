# This resource is the actual Kubernetes master cluster

resource "aws_eks_cluster" "demo" {
  name            = "${var.cluster-name}"
  role_arn        = "${aws_iam_role.demo-cluster.arn}"
  enabled_cluster_log_types = ["api", "audit"]

  vpc_config {
    security_group_ids = ["${aws_security_group.demo-cluster.id}"]
    subnet_ids         = ["${aws_subnet.demo.*.id}"]
    # https://www.terraform.io/docs/providers/aws/r/eks_cluster.html#endpoint_public_access
    endpoint_private_access = true # Kubernetes API requests within your cluster's VPC (such as worker node to control plane communication) use the private VPC endpoint. if this is disabled, then any kubectl commands must come from within the VPC
    endpoint_public_access  = true # Your cluster API server is accessible from the internet
  }

  depends_on = [
    "aws_iam_role_policy_attachment.demo-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.demo-cluster-AmazonEKSServicePolicy",
    "aws_cloudwatch_log_group.example",
  ]
}

# EKS Control Plane Logging can be enabled via the enabled_cluster_log_types argument.
# To manage the CloudWatch Log Group retention period, the aws_cloudwatch_log_group resource can be used.
resource "aws_cloudwatch_log_group" "example" {
  name             = "/aws/eks/${var.cluster-name}/cluster"
  retention_in_days = 5
}
