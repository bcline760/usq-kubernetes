variable "annotations" {
  type    = map(string)
  default = null
}

variable "default_backend" {
  type = object({
    resource = optional(object({
      api_group = string
      kind      = string
      name      = string
    }))
    service = optional(object({
      name = string
      port = object({
        num = number
      })
    }))
  })
  default = null
}

variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "rules" {
  type = list(object({
    host = string
    paths = optional(list(object({
      path      = optional(string)
      path_type = optional(string)
      backend = optional(object({
        resource = optional(object({
          api_group = string
          kind      = string
          name      = string
        }))
        service = optional(object({
          name        = string
          port_number = number
        }))
      }))
    })))
  }))
}
