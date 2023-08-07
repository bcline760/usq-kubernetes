variable "containers" {
  type = list(object({
    command           = optional(list(string))
    command_args      = optional(list(string))
    image             = string
    image_pull_policy = optional(string)
    name              = string
    port              = optional(number)

    env = optional(list(object({
      name  = string
      value = optional(string)
      value_from = optional(object({
        config_map_key_ref = optional(object({
          key      = string
          name     = string
          optional = bool
        }))

        field_ref = optional(object({
          api_version = string
          field_path  = string
        }))

        resource_field_ref = optional(object({
          container_name = string
          divisor        = string
          resource       = string
        }))

        secret_key_ref = optional(object({
          key      = string
          name     = string
          optional = bool
        }))
      }))
    })))

    liveness_probe = optional(object({
      failure_threshold     = optional(number)
      initial_delay_seconds = optional(number)
      period_seconds        = optional(number)
      success_threshold     = optional(number)
      timeout_seconds       = optional(number)

      exec = optional(object({
        command = string
      }))

      grpc = optional(object({
        port    = string
        service = string
      }))

      http_get = optional(object({
        host   = string
        path   = string
        port   = string
        scheme = string
      }))

      tcp_socket = optional(object({
        port = string
      }))
    }))

    ports = optional(list(object({
      container_port = number
      host_ip        = optional(string)
      host_port      = optional(string)
      name           = optional(string)
      protocol       = optional(string)
    })))

    readiness_probe = optional(object({
      failure_threshold     = optional(number)
      initial_delay_seconds = optional(number)
      period_seconds        = optional(number)
      success_threshold     = optional(number)
      timeout_seconds       = optional(number)

      exec = optional(object({
        command = string
      }))

      grpc = optional(object({
        port    = string
        service = string
      }))

      http_get = optional(object({
        host   = string
        path   = string
        port   = string
        scheme = string
      }))

      tcp_socket = optional(object({
        port = string
      }))
    }))

    volume_mounts = optional(list(object({
      mount_path        = string
      mount_propagation = optional(string)
      name              = string
      read_only         = optional(bool)
      sub_path          = optional(string)
    })))
  }))
}

variable "labels" {
  type = map(string)
}

variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "volumes" {
  type = list(object({
    name = string
    persistent_volume_claim = optional(object({
      claim_name = string
      read_only  = bool
    }))
  }))

  default = null
}
