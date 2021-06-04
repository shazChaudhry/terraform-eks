// Kubernetes Dashboard
// https://registry.terraform.io/modules/cookielab/dashboard/kubernetes/latest
module "kubernetes_dashboard" {
  source = "cookielab/dashboard/kubernetes"

  kubernetes_dashboard_csrf = "<your-csrf-random-string>"
}

resource "kubernetes_service_account" "admin-user" {
  metadata {
    name      = "admin-user"
    namespace = "kubernetes-dashboard"
  }
  depends_on = [module.kubernetes_dashboard]
}

resource "kubernetes_cluster_role_binding" "admin-user" {
  metadata {
    name = "admin-user"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.admin-user.metadata.0.name
    namespace = kubernetes_service_account.admin-user.metadata.0.namespace
  }
}