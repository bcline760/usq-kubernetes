resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    annotations = var.annotations
    labels      = var.labels
    name        = var.name
  }
}
