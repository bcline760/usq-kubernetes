resource "kubernetes_persistent_volume_claim_v1" "pvc" {
  wait_until_bound = var.wait_until_bound

  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    access_modes       = var.access_modes
    storage_class_name = var.storage_class_name
    volume_name        = var.volume_name

    resources {
      limits   = var.resource_limits
      requests = var.resource_requests
    }
  }
}
