resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  spec {
    dynamic "default_backend" {
      for_each = var.default_backend != null ? [var.default_backend] : []
      content {
        dynamic "resource" {
          for_each = default_backend.value.resource != null ? [default_backend.value.resource] : []
          content {
            api_group = resource.value.api_group
            kind      = resource.value.kind
            name      = resource.value.name
          }
        }
        dynamic "service" {
          for_each = default_backend.value.service != null ? [default_backend.value.service] : []
          content {
            name = service.value.name
            port {
              number = service.value.num
            }
          }
        }
      }
    }

    dynamic "rule" {
      for_each = var.rules
      content {
        host = rule.value.host
        http {
          dynamic "path" {
            for_each = rule.value.paths
            content {
              path      = path.value.path
              path_type = path.value.path_type
              dynamic "backend" {
                for_each = path.value.backend != null ? [path.value.backend] : []
                content {
                  dynamic "resource" {
                    for_each = backend.value.resource != null ? [backend.value.resource] : []
                    content {
                      api_group = resource.value.api_group
                      kind      = resource.value.kind
                      name      = resource.value.name
                    }
                  }
                  dynamic "service" {
                    for_each = backend.value.service != null ? [backend.value.service] : []
                    content {
                      name = service.value.name
                      port {
                        number = service.value.port_number
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
