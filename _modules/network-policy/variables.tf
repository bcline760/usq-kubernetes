variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "pod_selector" {
  type = map(string)
}

variable "ports" {
  type = object({
    egress = optional(list(object({
      port     = number
      protocol = string
    })))
    ingress = optional(list(object({
      port     = number
      protocol = string
    })))
  })

  default = null
}
