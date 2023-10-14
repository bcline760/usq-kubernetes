resource "kubernetes_config_map_v1" "config_map" {
  binary_data = var.binary_config_data
  data        = var.config_data
  immutable   = var.immutable

  metadata {
    annotations = var.annotations
    labels      = var.labels
    name        = var.name
    namespace   = var.namespace
  }
}
