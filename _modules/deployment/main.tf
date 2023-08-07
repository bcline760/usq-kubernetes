resource "kubernetes_deployment_v1" "deployment" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = var.labels
  }
  spec {
    selector {
      match_labels = var.labels
    }

    template {
      metadata {
        labels = var.labels
      }

      spec {
        dynamic "container" {
          for_each = var.containers
          content {
            name              = container.value.name
            args              = container.value.command_args
            command           = container.value.command
            image             = container.value.image
            image_pull_policy = container.value.image_pull_policy

            dynamic "env" {
              for_each = container.value.env != null ? container.value.env : []
              content {
                name  = env.value.name
                value = env.value.value

                dynamic "value_from" {
                  for_each = env.value.value_from != null ? [env.value.value_from] : []
                  content {
                    dynamic "config_map_key_ref" {
                      for_each = value_from.value.config_map_key_ref != null ? [value_from.value.config_map_key_ref] : []
                      content {
                        key      = config_map_key_ref.value.key
                        name     = config_map_key_ref.value.name
                        optional = config_map_key_ref.value.optional
                      }
                    }

                    dynamic "field_ref" {
                      for_each = value_from.value.field_ref != null ? [value_from.value.field_ref] : []
                      content {
                        api_version = field_ref.value.api_version
                        field_path  = field_ref.value.field_path
                      }
                    }

                    dynamic "resource_field_ref" {
                      for_each = value_from.value.resource_field_ref != null ? [value_from.value.resource_field_ref] : []
                      content {
                        container_name = resource_field_ref.value.container_name
                        divisor        = resource_field_ref.value.divisor
                        resource       = resource_field_ref.value.resource
                      }
                    }

                    dynamic "secret_key_ref" {
                      for_each = value_from.value.secret_key_ref != null ? [value_from.value.secret_key_ref] : []
                      content {
                        key      = secret_key_ref.value.key
                        name     = secret_key_ref.value.name
                        optional = secret_key_ref.value.optional
                      }
                    }
                  }
                }
              }
            }

            dynamic "liveness_probe" {
              for_each = container.value.liveness_probe != null ? [container.value.liveness_probe] : []
              content {
                failure_threshold     = liveness_probe.value.failure_threshold
                initial_delay_seconds = liveness_probe.value.initial_delay_seconds
                period_seconds        = liveness_probe.value.period_seconds
                success_threshold     = liveness_probe.value.success_threshold
                timeout_seconds       = liveness_probe.value.timeout_seconds

                dynamic "exec" {
                  for_each = liveness_probe.value.exec != null ? [liveness_probe.value.exec] : []
                  content {
                    command = exec.value.command
                  }
                }
              }
            }

            dynamic "port" {
              for_each = container.value.ports
              content {
                container_port = port.value.container_port
                host_ip        = port.value.host_ip
                host_port      = port.value.host_port
                name           = port.value.name
                protocol       = port.value.protocol
              }
            }

            dynamic "readiness_probe" {
              for_each = container.value.readiness_probe != null ? [container.value.readiness_probe] : []
              content {
                failure_threshold     = readiness_probe.value.failure_threshold
                initial_delay_seconds = readiness_probe.value.initial_delay_seconds
                period_seconds        = readiness_probe.value.period_seconds
                success_threshold     = readiness_probe.value.success_threshold
                timeout_seconds       = readiness_probe.value.timeout_seconds

                dynamic "exec" {
                  for_each = readiness_probe.value.exec != null ? [readiness_probe.value.exec] : []
                  content {
                    command = exec.value.command
                  }
                }
              }
            }

            dynamic "volume_mount" {
              for_each = container.value.volume_mounts
              content {
                mount_path        = volume_mount.value.mount_path
                mount_propagation = volume_mount.value.mount_propagation
                name              = volume_mount.value.name
                read_only         = volume_mount.value.read_only
                sub_path          = volume_mount.value.sub_path
              }
            }
          }
        }

        dynamic "volume" {
          for_each = var.volumes
          content {
            name = volume.value.name
            dynamic "persistent_volume_claim" {
              for_each = volume.value.persistent_volume_claim != null ? [volume.value.persistent_volume_claim] : []
              content {
                claim_name = persistent_volume_claim.value.claim_name
                read_only  = persistent_volume_claim.value.read_only
              }
            }
          }
        }
      }
    }
  }
}