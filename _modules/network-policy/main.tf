resource "kubernetes_network_policy_v1" "netpol" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  spec {
    policy_types = local.policy_types

    pod_selector {
      match_labels = var.pod_selector
    }

    egress {
      dynamic "ports" {
        for_each = var.ports.egress == null ? [] : var.ports.egress
        content {
          port     = ports.value.port
          protocol = ports.value.protocol
        }
      }
    }
    ingress {
      dynamic "ports" {
        for_each = var.ports.ingress == null ? [] : var.ports.ingress
        content {
          port     = ports.value.port
          protocol = ports.value.protocol
        }
      }
    }
  }
}
